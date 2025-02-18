module Types
  class LinksType < Types::BaseObject
    field :available_translations, [EditionType], null: true
    field :links_of_type, [EditionType] do
      argument :type, String, required: true
      argument :reverse, Boolean, default_value: false
    end

    def available_translations
      Sequel::Model.db[:editions]
                   .join(:documents, id: :document_id, content_id: object[:content_id])
                   .where(state: object[:include_drafts] ? %w[published draft] : %w[published])
    end

    # rubocop:disable Lint/UnusedMethodArgument
    def links_of_type(type:, reverse:) = object.dig(:links, type)
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
