module Types
  class LinksType < Types::BaseObject
    field :links_of_type, [EditionType] do
      argument :type, String, required: true
      argument :reverse, Boolean, default_value: false
    end

    def links_of_type(type:, reverse:) = object[type]
  end
end
