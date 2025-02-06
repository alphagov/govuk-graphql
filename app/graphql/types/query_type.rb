# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :edition, resolver: Resolvers::ExpandedEditionResolver
  end
end
