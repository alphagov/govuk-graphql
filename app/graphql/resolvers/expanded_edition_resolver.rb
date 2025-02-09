# frozen_string_literal: true
module Resolvers
  class ExpandedEditionResolver < BaseResolver
    type Types::EditionType, null: true
    description "Edition with expanded links"

    argument :base_path, String, required: true
    extras [ :lookahead ]

    def initialize(*args, **kwargs, &block)
      super
    end

    def resolve(base_path:, lookahead:)
      forward_paths, reverse_paths = PathTreeHelpers.build_paths(lookahead)

      rows = ExpandedEditionDataset.instance.get_or_prepare_statement
               .call(
                 link_type_paths: Sequel.pg_json_wrap(forward_paths),
                 reverse_link_type_paths: Sequel.pg_json_wrap(reverse_paths),
                 base_path:
               )

      PathTreeHelpers.nest_results(rows)
    end
  end
end
