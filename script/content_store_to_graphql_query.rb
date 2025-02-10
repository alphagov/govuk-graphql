#!/usr/bin/env ruby

require 'json'

class GraphQLQueryBuilder
  def initialize(old_response)
    @data = old_response
  end

  def build_query
    <<~GRAPHQL
      query {
        edition(base_path: "#{@data['base_path']}") {
          #{build_fields(@data)}
        }
      }
    GRAPHQL
  end

  private

  def build_fields(data, indent = 4)
    fields = data.map do |key, value|
      case value
      when Hash
        "#{key} {\n#{' ' * (indent + 2) + build_fields(value, indent + 2)}\n#{' ' * indent}}"
      when Array
        build_links_query(key, value, indent)
      else
        key
      end
    end
    fields.compact.join("\n#{' ' * indent}")
  end

  def build_links_query(key, array, indent)
    return nil unless array.all? { |item| item.is_a?(Hash) }

    link_type = key # Assuming the key matches the GraphQL link type
    <<~GRAPHQL.strip
      #{key}: links_of_type(type: "#{link_type}") {
        #{' ' * indent + build_fields(array.first, indent + 2)}
      #{' ' * indent}}
    GRAPHQL
  end
end

content_store_response = JSON.parse(ARGF.read)
query_builder = GraphQLQueryBuilder.new(content_store_response)
puts query_builder.build_query
