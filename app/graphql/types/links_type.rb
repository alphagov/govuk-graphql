module Types
  class LinksType < Types::BaseObject
    field :links_of_type, [EditionType] do
      argument :type, String, required: true
    end

    def links_of_type(type:)
      p object.keys
      object[type]
    end
  end
end
