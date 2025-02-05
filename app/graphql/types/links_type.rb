module Types
  class LinksType < Types::BaseObject
    field :links_of_type, [EditionType], null: false do
      argument :type, String, required: true
    end

    def links_of_type(type:)
      object[type]
    end
  end
end
