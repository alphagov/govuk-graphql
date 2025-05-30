module Types
  class LinksType < Types::BaseObject
    field :available_translations, [EditionType], null: true, extras: [:lookahead]
    field :links_of_type, [EditionType], extras: [:ast_node] do
      argument :type, LinkType, required: true
      argument :reverse, Boolean, default_value: false
    end

    def available_translations(lookahead:)
      state_filter = [
        "published",
        ("draft" if object[:include_drafts]),
        ("unpublished" if object[:include_withdrawn]),
      ].compact

      always_selected_columns = Set[
        :base_path,
        :locale,
        :content_id,
      ]
      selected_edition_columns = lookahead.selections.map(&:name).map(&:to_sym).to_set & PathTreeHelpers::ALL_EDITION_COLUMNS
      selected_columns = always_selected_columns + selected_edition_columns

      Sequel::Model.db[:editions]
                   .join(:documents, id: :document_id, content_id: object[:content_id])
                   .then {
                     if object[:include_withdrawn]
                       it.left_outer_join(:unpublishings, edition_id: Sequel[:editions][:id])
                         .where(Sequel.|(
                                  { state: "unpublished", Sequel[:unpublishings][:type] => "withdrawal" },
                                  Sequel.~(state: "unpublished"),
                                ))
                     else
                       it
                     end
                   }
                   .where(state: state_filter)
                   .select(*selected_columns)
    end

    # rubocop:disable Lint/UnusedMethodArgument
    def links_of_type(type:, reverse:, ast_node:)
      key = ast_node.alias || type
      object.dig(:links, key)
    end
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
