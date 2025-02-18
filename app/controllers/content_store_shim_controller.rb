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
      # Find the appropriate graphql query for this schema
      File.open(Rails.root.join("app/graphql/queries/#{edition[:schema_name]}.graphql"), "r") do |file|
        query = file.read
        # Execute the query
        result = GovukGraphqlSchema.execute(query, variables: { base_path: base_path })
        render json: result.dig("data", "edition")
      end
    end
  end
end
