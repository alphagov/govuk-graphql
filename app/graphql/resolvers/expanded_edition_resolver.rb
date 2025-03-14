# frozen_string_literal: true

module Resolvers
  class ExpandedEditionResolver < BaseResolver
    type Types::EditionType, null: true
    description "Edition with expanded links"

    argument :base_path, String, required: true
    argument :include_drafts, Boolean, required: false, default_value: false
    argument :include_withdrawn, Boolean, required: false, default_value: false
    argument :locale, String, required: false, default_value: "en"
    extras [:lookahead]

    def initialize(*args, **kwargs, &block)
      super
    end

    def resolve(base_path:, include_drafts:, include_withdrawn:, locale:, lookahead:)
      forward_paths, reverse_paths = PathTreeHelpers.build_paths(lookahead)

      rows = ExpandedEditionDataset.instance.get_or_prepare_statement(include_drafts:, include_withdrawn:, locale:)
               .call(
                 link_type_paths: Sequel.pg_json_wrap(forward_paths),
                 reverse_link_type_paths: Sequel.pg_json_wrap(reverse_paths),
                 base_path:,
               )
      return nil if rows.empty?

      PathTreeHelpers.nest_results(rows).merge(include_drafts:, include_withdrawn:)
    end
  end
end
