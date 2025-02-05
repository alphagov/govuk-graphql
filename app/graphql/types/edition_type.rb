module Types
  class EditionType < Types::BaseObject
    field :title, String, null: false
    field :links, LinksType

    def title
      object[:node][:title]
    end

    def links
      object[:children]
    end
  end
end