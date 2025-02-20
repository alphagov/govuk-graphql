class ContentStoreShimController < ApplicationController
  # The /api/content endpoint is public and unauthenticated for published editions
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session

  def content_item
    base_path = "/#{params[:base_path]}"
    edition = Sequel::Model.db[:editions].where(base_path:, state: "published").first
    if edition.nil?
      render json: { error: "Not found" }, status: :not_found
    else
      render json: get_graphql_content_item(edition, base_path)
    end
  end

  def compare_content_item
    base_path = "/#{params[:base_path]}"
    edition = Sequel::Model.db[:editions].where(base_path:, state: "published").first

    if edition.nil?
      render json: { error: "Not found" }, status: :not_found
    else
      graphql_content_item = sort_links(get_graphql_content_item(edition, base_path))
      content_store_content_item = sort_links(GdsApi.content_store.content_item(base_path).to_h)
      diff = Hashdiff.diff(
        content_store_content_item,
        graphql_content_item,
        similarity: 0.5,
        ignore_keys: %w[public_updated_at],
      ) do |_path, left, right|
        # If both sides are blank, consider them equal (even though they might be null, "" or {} etc.)
        true if left.blank? && right.blank?
      end
      render json: {
        diff:,
        graphql_content_item:,
        content_store_content_item:,
      }
    end
  end

private

  def get_graphql_content_item(edition, base_path)
    # Find the appropriate graphql query for this schema
    schema_name = edition.fetch(:schema_name)
    set_prometheus_labels(schema_name)
    File.open(Rails.root.join("app/graphql/queries/#{schema_name}.graphql"), "r") do |file|
      query = file.read
      # Execute the query
      result = GovukGraphqlSchema.execute(query, variables: { base_path: base_path })
      result.dig("data", "edition")
    end
  end

  def sort_links(input)
    return unless input.is_a?(Hash)

    links = input["links"]
    return unless links.is_a?(Hash)

    links.each_value do |arr|
      arr&.each { sort_links(it) }
      arr&.sort_by! { it["base_path"] || it["content_id"] }
    end

    input
  end
end
