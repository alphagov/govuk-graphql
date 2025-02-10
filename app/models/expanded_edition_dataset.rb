# frozen_string_literal: true

class ExpandedEditionDataset
  prepend MemoWise
  include Singleton

  def get_or_prepare_statement(include_drafts: false, include_withdrawn: false, locale: "en")
    db = Sequel::Model.db

    # example of a withdrawn edition with a withdrawn parent: https://www.gov.uk/government/publications/revenue-and-customs-brief-10-2013-withdrawal-of-the-vat-exemption-for-supplies-of-research/revenue-and-customs-brief-10-2013-withdrawal-of-the-vat-exemption-for-supplies-of-research

    paths_from_json_sql = <<~SQL
      SELECT path, next, columns
      FROM json_to_recordset(?) AS paths(path text[], next text, columns jsonb)
    SQL

    state_filter = ["published", ("draft" if include_drafts), ("unpublished" if include_withdrawn)].compact
    locale_filter = [locale, "en"].uniq

    link_type_ds = db[paths_from_json_sql, :$link_type_paths]
    reverse_link_type_ds = db[paths_from_json_sql, :$reverse_link_type_paths]

    root_selections = [
      Sequel.pg_array([], "text").as(:path),
      Sequel.pg_array([Sequel[:editions][:id]], "int").as(:id_path),
      Sequel[:documents][:content_id].as(:content_id),
      Sequel[:documents][:locale].as(:locale),
      Sequel[:editions][:id].as(:edition_id),
      Sequel[0].as(:position),
      (Sequel[:unpublishings][:type].as(:unpublishing_type) if include_withdrawn),
      Sequel[:editions][:state],
      *PathTreeHelpers::ALL_EDITION_COLUMNS.without(:state).map { Sequel[:editions][it] },
    ].compact
    child_selections = [
      Sequel[:edition_links][:path].pg_array.push(:link_type).as(:path),
      Sequel[:edition_links][:id_path].pg_array.push(Sequel[:editions][:id]).as(:id_path),
      Sequel[:documents][:content_id].as(:content_id),
      Sequel[:documents][:locale].as(:locale),
      Sequel[:editions][:id].as(:edition_id),
      Sequel[:links][:position],
      (Sequel[:unpublishings][:type].as(:unpublishing_type) if include_withdrawn),
      Sequel[:editions][:state],
      *PathTreeHelpers::ALL_EDITION_COLUMNS.without(:state).map do |col|
        Sequel.case({ Sequel.lit("(columns->'#{col}')::boolean") => Sequel[:editions][col] }, nil).as(col)
      end,
    ].compact

    root_edition = db[:editions]
                     .join(:documents, id: :document_id, locale: locale_filter)
                     .then { include_withdrawn ? it.left_outer_join(:unpublishings, edition_id: Sequel[:editions][:id]) : it }
                     .where(state: state_filter, base_path: :$base_path)
                     .select(Sequel["0 - root"].as(:type), *root_selections)

    edition_links_and_paths = db[:edition_links].join(:link_type_paths, path: :path)
    forward_editions = edition_links_and_paths
                         .join(:links, edition_id: Sequel[:edition_links][:edition_id], link_type: Sequel[:link_type_paths][:next])
                         .join(:documents, content_id: :target_content_id, locale: locale_filter)
                         .join(:editions, document_id: :id, state: state_filter)
                         .then { include_withdrawn ? it.left_outer_join(:unpublishings, edition_id: Sequel[:editions][:id]) : it }
                         .select(Sequel["1 - forward edition"].as(:type), *child_selections)

    forward_link_sets = edition_links_and_paths
                          .join(:link_sets, content_id: Sequel[:edition_links][:content_id])
                          .join(:links, link_set_id: :id, link_type: Sequel[:link_type_paths][:next])
                          .join(:documents, content_id: :target_content_id, locale: locale_filter)
                          .join(:editions, document_id: :id, state: state_filter)
                          .then { include_withdrawn ? it.left_outer_join(:unpublishings, edition_id: Sequel[:editions][:id]) : it }
                          .select(Sequel["2 - forward link set"].as(:type), *child_selections)

    reverse_editions = db[:edition_links]
                         .join(:reverse_link_type_paths, path: :path)
                         .join(:links, target_content_id: Sequel[:edition_links][:content_id], link_type: Sequel[:reverse_link_type_paths][:next])
                         .join(:editions, id: :edition_id, state: state_filter)
                         .join(:documents, id: :document_id, locale: locale_filter)
                         .then { include_withdrawn ? it.left_outer_join(:unpublishings, edition_id: Sequel[:editions][:id]) : it }
                         .select(Sequel["3 - reverse edition"].as(:type), *child_selections)

    reverse_link_sets = db[:edition_links]
                          .join(:reverse_link_type_paths, path: :path)
                          .join(:links, target_content_id: Sequel[:edition_links][:content_id], link_type: Sequel[:reverse_link_type_paths][:next])
                          .join(:link_sets, id: :link_set_id)
                          .join(:documents, content_id: :content_id, locale: locale_filter)
                          .join(:editions, document_id: :id, state: state_filter)
                          .then { include_withdrawn ? it.left_outer_join(:unpublishings, edition_id: Sequel[:editions][:id]) : it }
                          .select(Sequel["4 - reverse link set"].as(:type), *child_selections)

    recursive_term =
      forward_editions
        .union(reverse_editions, all: true, from_self: false)
        .union(forward_link_sets, all: true, from_self: false)
        .union(reverse_link_sets, all: true, from_self: false)
        # This shadowing is required as a workaround for the fact that postgres will not let you refer to the recursive term more than once
        .with(:edition_links, db[:edition_links])

    candidate_editions = db[:edition_links]
      .with(:link_type_paths, link_type_ds)
      .with(:reverse_link_type_paths, reverse_link_type_ds)
      .with_recursive(:edition_links, root_edition, recursive_term)
      .then do
        if include_withdrawn
          it.where(Sequel.|(
                     { state: "unpublished", unpublishing_type: "withdrawal" },
                     Sequel.~(state: "unpublished"),
                   ))
        else
          it
        end
      end

    locale_ordering = Sequel.case({ { locale: locale } => 0 }, 1)
    state_ordering = Sequel.case({
      { state: "draft" } => 0,
      { state: "published" } => 1,
      { state: "unpublished" } => 2,
    },
                                 3)
    candidate_editions
      .select_append(
        Sequel.function(:row_number)
              .over(
                partition: %i[path content_id],
                order: [locale_ordering, state_ordering, :type],
              ).as(:row_number),
      )
      .from_self(alias: :candidate_editions)
      .where(Sequel[:row_number] => 1)
      .order(:path, :position)
      .prepare(:select, [
        "expanded_editions",
        locale,
        ("include_drafts" if include_drafts),
        ("include_withdrawn" if include_withdrawn),
      ].compact.join("_").to_sym)
  end
  memo_wise :get_or_prepare_statement
end
