#!/usr/bin/env ruby

require "json"

class GraphqlQueryBuilder
  SPECIAL_LINK_TYPES = %w[
    available_translations
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
      query #{@data['schema_name']}($base_path: String!) {
        edition(base_path: $base_path) {
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
      in [ String => key, String | Numeric | true | false | nil ]
        key
      end
    end
    fields.compact.join("\n#{' ' * indent}")
  end

  def build_links_query(key, array, indent)
    link_type = REVERSE_LINK_TYPES[key] || key
    reverse = REVERSE_LINK_TYPES.key?(key)

    if SPECIAL_LINK_TYPES.include?(key)
      [
        "#{key} {",
        " " * (indent + 2) + build_fields(array.first, indent + 2),
        "#{' ' * indent}}",
      ].join("\n")
    else
      [
        "#{key}: links_of_type(type: \"#{link_type}\"#{', reverse: true' if reverse}) {",
        " " * (indent + 2) + build_fields(array.first, indent + 2),
        "#{' ' * indent}}",
      ].join("\n")
    end
  end
end
