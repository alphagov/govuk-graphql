class ContentStoreShimController < ApplicationController
  # The /api/content endpoint is public and unauthenticated for published editions
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session
  append_view_path "app/graphql/queries"

  def content_item
    base_path = "/#{params[:base_path]}"
    edition = Sequel::Model.db[:editions]
                           .join(:documents, id: :document_id)
                           .where(base_path:, state: "published")
                           .first
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
    schema_name = edition.fetch(:schema_name)
    locale = edition.fetch(:locale)
    set_prometheus_labels(schema_name:, locale:)
    query = render_to_string template: schema_name, formats: %i[graphql]
    result = GovukGraphqlSchema.execute(query, variables: { base_path:, locale: })
    errors = result["errors"]
    edition = result.dig("data", "edition") {}
    edition["graphql_errors"] = errors if errors.present?
    edition
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
