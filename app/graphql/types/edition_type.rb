module Types
  class EditionType < Types::BaseObject
    field :id, Integer, null: false
    field :title, String, null: false
    field :public_updated_at, String, null: false
    field :publishing_app, String, null: false
    field :rendering_app, String, null: false
    field :update_type, String, null: true
    field :phase, String, null: true
    field :analytics_identifier, String, null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :document_type, String, null: false
    field :schema_name, String, null: false
    field :first_published_at, String, null: true
    field :last_edited_at, String, null: true
    field :state, String, null: false
    field :user_facing_version, String, null: true
    field :base_path, String, null: true
    field :content_store, String, null: false
    field :document_id, Integer, null: false
    field :description, String, null: true
    field :publishing_request_id, String, null: true
    field :major_published_at, String, null: true
    field :published_at, String, null: true
    field :publishing_api_first_published_at, String, null: true
    field :publishing_api_last_edited_at, String, null: true
    field :details, Types::DetailsType, null: false
    field :routes, GraphQL::Types::JSON, null: true
    field :redirects, GraphQL::Types::JSON, null: true
    field :last_edited_by_editor_id, String, null: true
    field :content_id, String, null: false

    field :api_path, String, null: false
    def api_path = "/api/content#{object[:base_path]}".chomp("/")

    field :api_url, String, null: false
    def api_url = "#{website_root}/api/content#{object[:base_path]}".chomp("/")

    field :web_url, String, null: false
    def web_url = "#{website_root}#{object[:base_path]}".chomp("/")

    field :links, LinksType
    field :locale, String, null: false

    field :withdrawn, Boolean, null: false
    def withdrawn = object[:unpublishing_type] == "withdrawal"

  private

    def website_root
      ENV.fetch("GOVUK_WEBSITE_ROOT", "https://www.gov.uk")
    end
  end
end
