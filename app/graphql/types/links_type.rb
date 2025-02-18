module Types
  class LinksType < Types::BaseObject
    field :available_translations, [EditionType], null: true
    field :links_of_type, [EditionType] do
      argument :type, String, required: true
      argument :reverse, Boolean, default_value: false
    end

    def available_translations
      state_filter = [
        "published",
        ("draft" if object[:include_drafts]),
        ("unpublished" if object[:include_withdrawn]),
      ].compact

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
    end

    # rubocop:disable Lint/UnusedMethodArgument
    def links_of_type(type:, reverse:) = object.dig(:links, type)
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
