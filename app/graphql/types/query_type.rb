# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :edition, resolver: Resolvers::ExpandedEditionResolver
    field :suggest_query, type: String, null: true do
      argument :base_path, String, required: true
      argument :use_fragments, Boolean, required: false
    end

    def suggest_query(base_path:, use_fragments: false)
      content_store_response = fetch_content(base_path)
      query_builder = GraphqlQueryBuilder.new(content_store_response, use_fragments)
      query_builder.build_query
    end

  private

    def fetch_content(base_path)
      url = URI("https://www.gov.uk/api/content#{base_path}".chomp("/"))
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        raise "HTTP request failed with status #{response.code} #{response.message}"
      end
    end
  end
end
