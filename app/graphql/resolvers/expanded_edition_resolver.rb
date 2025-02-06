# frozen_string_literal: true

# TODO - delete this:
module MinistersIndex
  LINK_TYPE_PATHS = [
    { path: ['ordered_cabinet_ministers'] },
    { path: ['ordered_also_attends_cabinet'] },
    { path: ['ordered_assistant_whips'] },
    { path: ['ordered_baronesses_and_lords_in_waiting_whips'] },
    { path: ['ordered_house_lords_whips'] },
    { path: ['ordered_house_of_commons_whips'] },
    { path: ['ordered_junior_lords_of_the_treasury_whips'] },
    { path: ['ordered_ministerial_departments'] },
    { path: ['ordered_ministerial_departments', 'ordered_ministers'] },
    # TODO - this is nuts - we're getting every role in every department, just so we can check
    # if a minister's role exists within a particular department
    # { path: ['ordered_ministerial_departments', 'ordered_roles'] },
    # Note: person is a reverse link, content-store calls in role_appointments
    { path: ['ordered_cabinet_ministers', 'person', 'role'] },
    { path: ['ordered_also_attends_cabinet', 'person', 'role'] },
    { path: ['ordered_assistant_whips', 'person', 'role'] },
    { path: ['ordered_baronesses_and_lords_in_waiting_whips', 'person', 'role'] },
    { path: ['ordered_house_lords_whips', 'person', 'role'] },
    { path: ['ordered_house_of_commons_whips', 'person', 'role'] },
    { path: ['ordered_junior_lords_of_the_treasury_whips', 'person', 'role'] },
    { path: ['ordered_ministerial_departments', 'ordered_ministers', 'person', 'role'] }
  ]

  REVERSE_LINK_TYPE_PATHS = [
    { path: ['ordered_cabinet_ministers', 'person'] },
    { path: ['ordered_also_attends_cabinet', 'person'] },
    { path: ['ordered_assistant_whips', 'person'] },
    { path: ['ordered_baronesses_and_lords_in_waiting_whips', 'person'] },
    { path: ['ordered_house_lords_whips', 'person'] },
    { path: ['ordered_house_of_commons_whips', 'person'] },
    { path: ['ordered_junior_lords_of_the_treasury_whips', 'person'] },
    { path: ['ordered_ministerial_departments', 'ordered_ministers', 'person'] }
  ]
end

module Resolvers
  class ExpandedEditionResolver < BaseResolver
    type Types::EditionType, null: true
    description "Edition with expanded links"

    argument :base_path, String, required: true
    extras [ :lookahead ]

    def initialize(*args, **kwargs, &block)
      super
      @prepared_statement = prepare_statement(Sequel::Model.db)
    end

    def resolve(base_path:, lookahead:)
      p PathTreeHelpers.extract_paths(lookahead)

      # TODO - get the paths from the lookahead object instead of hardcoding them
      rows = @prepared_statement.call(
        link_type_paths: Sequel.pg_json_wrap(MinistersIndex::LINK_TYPE_PATHS),
        reverse_link_type_paths: Sequel.pg_json_wrap(MinistersIndex::REVERSE_LINK_TYPE_PATHS),
        base_path:
      )

      PathTreeHelpers.nest_results(rows)
    end

  private

    def prepare_statement(db)
      paths_from_json_sql = "SELECT trim_array(path, 1) as path, path[array_upper(path, 1)] as next FROM json_to_recordset(?) AS paths(path text[])"

      link_type_ds = db[paths_from_json_sql, :$link_type_paths]
      reverse_link_type_ds = db[paths_from_json_sql, :$reverse_link_type_paths]

      def columns(type, path = nil)
        [
          Sequel[type].as(:type),
          (path || Sequel[:edition_links][:path].pg_array.push(:link_type)).as(:path),
          Sequel[:documents][:content_id].as(:content_id),
          Sequel[:editions][:id].as(:edition_id),
          Sequel[:editions].*
        ]
      end

      root_edition = db[:editions]
                       .join(:documents, id: :document_id)
                       .where(state: "published", locale: "en", base_path: :$base_path)
                       .select(*columns("root", Sequel.pg_array([], "text")))

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

      reverse_editions = db[:edition_links].join(:reverse_link_type_paths, path: :path)
                                            .join(:links, target_content_id: Sequel[:edition_links][:content_id], link_type: Sequel[:reverse_link_type_paths][:next])
                                            .join(:editions, id: :edition_id, state: "published")
                                            .join(:documents, id: :document_id, locale: "en")
                                            .select(*columns("reverse edition"))

      reverse_link_sets = db[:edition_links].join(:reverse_link_type_paths, path: :path)
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
        .prepare(:select, :select_edition_links)
    end
  end
end
