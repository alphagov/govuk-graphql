# frozen_string_literal: true

class ExpandedEditionDataset
  prepend MemoWise
  include Singleton

  def get_or_prepare_statement
    db = Sequel::Model.db

    # TODO - handle draft and unpublished/withdrawn editions
    # example of a withdrawn edition with a withdrawn parent: https://www.gov.uk/government/publications/revenue-and-customs-brief-10-2013-withdrawal-of-the-vat-exemption-for-supplies-of-research/revenue-and-customs-brief-10-2013-withdrawal-of-the-vat-exemption-for-supplies-of-research
    # TODO - handle non-english locales

    paths_from_json_sql = <<~SQL
      SELECT path, next, columns
      FROM json_to_recordset(?) AS paths(path text[], next text, columns jsonb)
    SQL

    link_type_ds = db[paths_from_json_sql, :$link_type_paths]
    reverse_link_type_ds = db[paths_from_json_sql, :$reverse_link_type_paths]

    def columns(type, root: false)
      [
        Sequel[type].as(:type),
        (root ? Sequel.pg_array([], "text") : Sequel[:edition_links][:path].pg_array.push(:link_type)).as(:path),
        (root ? Sequel.pg_array([ Sequel[:editions][:id] ], "int") : Sequel[:edition_links][:id_path].pg_array.push(Sequel[:editions][:id])).as(:id_path),
        Sequel[:documents][:content_id].as(:content_id),
        Sequel[:documents][:locale].as(:locale),
        Sequel[:editions][:id].as(:edition_id),
        *(
          root ?
            # Include all columns for the root edition
            PathTreeHelpers::ALL_EDITION_COLUMNS.map { |col| Sequel[:editions][col] } :
            # Filter columns for other editions
            PathTreeHelpers::ALL_EDITION_COLUMNS.map do |col|
              Sequel.case({ Sequel.lit("(columns->'#{col}')::boolean") => Sequel[:editions][col] }, nil).as(col)
            end
        ),
      ]
    end

    root_edition = db[:editions]
                     .join(:documents, id: :document_id)
                     .where(state: "published", locale: "en", base_path: :$base_path)
                     .select(*columns("root", root: true))

    edition_links_and_paths = db[:edition_links].join(:link_type_paths, path: :path)
    forward_editions = edition_links_and_paths
                         .join(:links, edition_id: Sequel[:edition_links][:edition_id], link_type: Sequel[:link_type_paths][:next])
                         .join(:documents, content_id: :target_content_id, locale: "en")
                         .join(:editions, document_id: :id, state: "published")
                         .select(*columns("forward edition"))

    forward_link_sets = edition_links_and_paths
                          .join(:link_sets, content_id: Sequel[:edition_links][:content_id])
                          .join(:links, link_set_id: :id, link_type: Sequel[:link_type_paths][:next])
                          .join(:documents, content_id: :target_content_id, locale: "en")
                          .join(:editions, document_id: :id, state: "published")
                          .select(*columns("forward link set"))

    reverse_editions = db[:edition_links]
                         .join(:reverse_link_type_paths, path: :path)
                         .join(:links, target_content_id: Sequel[:edition_links][:content_id], link_type: Sequel[:reverse_link_type_paths][:next])
                         .join(:editions, id: :edition_id, state: "published")
                         .join(:documents, id: :document_id, locale: "en")
                         .select(*columns("reverse edition"))

    reverse_link_sets = db[:edition_links]
                          .join(:reverse_link_type_paths, path: :path)
                          .join(:links, target_content_id: Sequel[:edition_links][:content_id], link_type: Sequel[:reverse_link_type_paths][:next])
                          .join(:link_sets, id: :link_set_id)
                          .join(:documents, content_id: :content_id, locale: "en")
                          .join(:editions, document_id: :id, state: "published")
                          .select(*columns("reverse link set"))

    recursive_term =
      forward_editions
        .union(reverse_editions, all: true, from_self: false)
        .union(forward_link_sets, all: true, from_self: false)
        .union(reverse_link_sets, all: true, from_self: false)
        # This shadowing is required as a workaround for the fact that postgres will not let you refer to the recursive term more than once
        .with(:edition_links, db[:edition_links])

    db[:edition_links]
      .with(:link_type_paths, link_type_ds)
      .with(:reverse_link_type_paths, reverse_link_type_ds)
      .with_recursive(:edition_links, root_edition, recursive_term)
      .prepare(:select, :expanded_editions)
  end
  memo_wise :get_or_prepare_statement
end
