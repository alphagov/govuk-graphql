#!/usr/bin/env ruby

require "json"

class GraphQLQueryBuilder
  # FIELDS_TO_IGNORE is a bit of a "to do" list really. We should implement these:
  FIELDS_TO_IGNORE = %w[
    api_path
    api_url
    web_url
    withdrawn
    publishing_scheduled_at
    scheduled_publishing_delay_seconds
  ].freeze

  REVERSE_LINK_TYPES = {
    "children" => "parent",
    "document_collections" => "documents",
    "policies" => "working_groups",
    "child_taxons" => "parent_taxons",
    "level_one_taxons" => "root_taxon",
    "part_of_step_navs" => "pages_part_of_step_nav",
    "related_to_step_navs" => "pages_related_to_step_nav",
    "secondary_to_step_navs" => "pages_secondary_to_step_nav",
    "role_appointments" => "TODO - can be person or role, depending on the expected type of its parent",
    "ministers" => "ministerial",
  }.freeze

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
    fields = data.flat_map do |entry|
      case entry
      in [String, {}]
        nil
      in [ "details", Hash => details ]
        [
          "details {",
          details.map { |details_key, _| "  #{details_key}" },
          "}",
        ]
      in [ "links", Hash => links ]
        [
          "links {",
          links.map { |link_key, link_value| "  #{build_links_query(link_key, link_value, indent + 2)}" },
          "}",
        ]
      in [ String => key, String | true | false | nil ]
        key unless FIELDS_TO_IGNORE.include?(key)
      end
    end
    fields.compact.join("\n#{' ' * indent}")
  end

  def build_links_query(key, array, indent)
    link_type = REVERSE_LINK_TYPES[key] || key
    reverse = REVERSE_LINK_TYPES.key?(key)
    [
      "#{key}: links_of_type(type: \"#{link_type}\"#{', reverse: true' if reverse}) {",
      " " * (indent + 2) + build_fields(array.first, indent + 2),
      "#{' ' * indent}}",
    ].join("\n")
  end
end

content_store_response = JSON.parse(ARGF.read)
query_builder = GraphQLQueryBuilder.new(content_store_response)
puts query_builder.build_query
