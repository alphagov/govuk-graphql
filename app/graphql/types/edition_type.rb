module Types
  class EditionType < Types::BaseObject
    field :id, Integer, null: false
    field :title, String, null: false
    field :public_updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :publishing_app, String, null: false
    field :rendering_app, String, null: false
    field :update_type, String, null: true
    field :phase, String, null: true
    field :analytics_identifier, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :document_type, String, null: false
    field :schema_name, String, null: false
    field :first_published_at, GraphQL::Types::ISO8601DateTime, null: true
    field :last_edited_at, GraphQL::Types::ISO8601DateTime, null: true
    field :state, String, null: false
    field :user_facing_version, Integer, null: true
    field :base_path, String, null: true
    field :content_store, String, null: false
    field :document_id, Integer, null: false
    field :description, String, null: true
    field :publishing_request_id, String, null: true
    field :major_published_at, GraphQL::Types::ISO8601DateTime, null: true
    field :published_at, GraphQL::Types::ISO8601DateTime, null: true
    field :publishing_api_first_published_at, GraphQL::Types::ISO8601DateTime, null: true
    field :publishing_api_last_edited_at, GraphQL::Types::ISO8601DateTime, null: true
    field :publishing_scheduled_at, GraphQL::Types::ISO8601DateTime, null: true
    field :scheduled_publishing_delay_seconds, Int, null: true

    field :details, Types::DetailsType, null: false
    def details = object[:details]
                    &.symbolize_keys
                    &.merge(parent: object)

    field :routes, GraphQL::Types::JSON, null: true
    field :redirects, GraphQL::Types::JSON, null: true
    field :last_edited_by_editor_id, String, null: true
    field :content_id, String, null: false

    field :api_path, String, null: false
    def api_path = "/api/content#{object[:base_path]}"

    field :api_url, String, null: false
    def api_url = "#{website_root}/api/content#{object[:base_path]}"

    field :web_url, String, null: false
    def web_url = "#{website_root}#{object[:base_path]}"

    field :links, LinksType
    def links = object

    field :locale, String, null: false

    field :withdrawn, Boolean, null: false
    def withdrawn = object[:unpublishing_type] == "withdrawal"

    field :withdrawn_notice, GraphQL::Types::JSON, null: false
    def withdrawn_notice
      return {} unless withdrawn

      withdrawn_at = (object[:unpublished_at] || object[:unpublishing_created_at]).iso8601
      {
        explanation: object[:explanation],
        withdrawn_at:,
      }
    end

    # Aliased by field methods for fields that are currently presented in the
    # content item, but come from Content Store, so we can't provide them here
    def not_stored_in_publishing_api = nil
    alias_method :publishing_scheduled_at, :not_stored_in_publishing_api
    alias_method :scheduled_publishing_delay_seconds, :not_stored_in_publishing_api

  private

    def app_domain_external
      ENV.fetch("GOVUK_APP_DOMAIN_EXTERNAL", "publishing.service.gov.uk")
    end

    def website_root
      ENV.fetch("GOVUK_WEBSITE_ROOT", "https://www.gov.uk")
    end
  end
end
