# frozen_string_literal: true

class ExpandedEditionDataset
  prepend MemoWise
  include Singleton

  PREPARED_STATEMENT_CACHE_SIZE = 1000

  def initialize
    @prepared_statement_names = []
    @prepared_statement_cache_counter = 0
    @mutex = Mutex.new
  end

  def select(*columns_to_return)
    db = Sequel::Model.db

    # This is very ugly...
    # We're caching prepared statements, because there's a good performance advantage
    # But each query has a different set of columns, so we end up with one prepared statement per query (roughly)
    # At some point, that would be a problem for postgres. So it would be nice to periodically deallocate the prepared statements
    # Unfortunately, I can't work out how to get Sequel to realise a prepared statement has been deallocated, other than
    # by changing its name. So we've got @prepared_statement_cache_counter to do that.
    # The point of this implementation is to go fast at all costs, so ¯\_(ツ)_/¯
    prepared_statement_name = nil
    @mutex.synchronize do
      if @prepared_statement_names.count > PREPARED_STATEMENT_CACHE_SIZE
        Sequel::Model.db.run("DEALLOCATE ALL")
        reset_memo_wise :select
        @prepared_statement_cache_counter += 1
        @prepared_statement_names = []
      end
      prepared_statement_name = :"select_#{Digest::SHA256.hexdigest(columns_to_return.join(","))}_#{@prepared_statement_cache_counter}"
      @prepared_statement_names << prepared_statement_name
    end

    # TODO - handle draft and unpublished/withdrawn editions
    # TODO - handle non-english locales

    paths_from_json_sql = <<~SQL
      SELECT path, next, include_details
      FROM json_to_recordset(?) AS paths(path text[], next text, include_details boolean)
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
        Sequel[(root ? true : :include_details)].as(:should_include_details),
        Sequel[:editions].*
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

    result = db[:edition_links]
      .with(:link_type_paths, link_type_ds)
      .with(:reverse_link_type_paths, reverse_link_type_ds)
      .with_recursive(:edition_links, root_edition, recursive_term)
      .select(
        :type,
        :path,
        :id_path,
        :content_id,
        :locale,
        :edition_id,
        *columns_to_return,
        Sequel.case({ { should_include_details: true } => :details }, nil).as(:details),
      )

    # NOTE - this might be a performance optimisation too far...
    # we're creating a prepared statement for every combination of columns requested
    result.prepare(:select, prepared_statement_name)
  end
  memo_wise :select
end
