module Types
  class EditionType < Types::BaseObject
    field :title, String, null: false
    field :links, LinksType

    def title
      object[:title]
    end

    def links
      object[:links]
    end
  end
end