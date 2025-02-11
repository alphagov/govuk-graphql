DB = Sequel::Model.db

DB.create_table?(:documents, ignore_index_errors: true) do
  primary_key :id
  String :content_id, null: false
  String :locale, null: false
  Integer :stale_lock_version, default: 0, null: false
  DateTime :created_at, null: false
  DateTime :updated_at, null: false
  Integer :owning_document_id

  index [:content_id, :locale], name: :index_documents_on_content_id_and_locale, unique: true
  index [:id, :locale], name: :index_documents_on_id_and_locale
end

DB.create_table?(:editions, ignore_index_errors: true) do
  primary_key :id
  String :title, text: true
  DateTime :public_updated_at
  String :publishing_app
  String :rendering_app
  String :update_type
  String :phase, default: "live"
  String :analytics_identifier
  DateTime :created_at, null: false
  DateTime :updated_at, null: false
  String :document_type
  String :schema_name
  DateTime :first_published_at
  DateTime :last_edited_at
  String :state, null: false
  Integer :user_facing_version, default: 1, null: false
  String :base_path, text: true
  String :content_store
  foreign_key :document_id, :documents, null: false, key: [:id]
  String :description, text: true
  String :publishing_request_id
  DateTime :major_published_at
  DateTime :published_at
  DateTime :publishing_api_first_published_at
  DateTime :publishing_api_last_edited_at
  String :auth_bypass_ids, null: false
  String :details
  String :routes
  String :redirects
  String :last_edited_by_editor_id
  
  index [:base_path, :content_store], name: :index_editions_on_base_path_and_content_store, unique: true
  index [:document_id], name: :index_editions_on_document_id
  index [:document_id, :content_store], name: :index_editions_on_document_id_and_content_store, unique: true
  index [:document_id, :state], name: :index_editions_on_document_id_and_state
  index [:document_id, :user_facing_version], name: :index_editions_on_document_id_and_user_facing_version, unique: true
  index [:document_type, :state], name: :index_editions_on_document_type_and_state
  index [:document_type, :updated_at], name: :index_editions_on_document_type_and_updated_at
  index [:id, :content_store], name: :index_editions_on_id_and_content_store
  index [:publishing_app], name: :index_editions_on_publishing_app
  index [:state, :base_path], name: :index_editions_on_state_and_base_path
  index [:updated_at], name: :index_editions_on_updated_at
  index [:updated_at, :id], name: :index_editions_on_updated_at_and_id
end

DB.create_table?(:link_sets, ignore_index_errors: true) do
  primary_key :id
  String :content_id
  DateTime :created_at
  DateTime :updated_at
  Integer :stale_lock_version, default: 0

  index [:content_id], name: :index_link_sets_on_content_id, unique: true
end

DB.create_table?(:links, ignore_index_errors: true) do
  primary_key :id
  foreign_key :link_set_id, :link_sets, key: [:id]
  String :target_content_id
  String :link_type, null: false
  DateTime :created_at, null: false
  DateTime :updated_at, null: false
  Integer :position, default: 0, null: false
  foreign_key :edition_id, :editions, key: [:id], on_delete: :cascade
  
  index [:edition_id], name: :index_links_on_edition_id
  index [:link_set_id], name: :index_links_on_link_set_id
  index [:link_set_id, :target_content_id], name: :index_links_on_link_set_id_and_target_content_id
  index [:link_type], name: :index_links_on_link_type
  index [:target_content_id], name: :index_links_on_target_content_id
  index [:target_content_id, :link_type], name: :index_links_on_target_content_id_and_link_type
end

DB.create_table?(:users) do
  primary_key :id
  String :name
  String :email
  String :uid
  String :organisation_slug
  String :organisation_content_id
  String :app_name
  String :permissions, text: true
  TrueClass :remotely_signed_out, default: false
  TrueClass :disabled, default: false
  DateTime :created_at
  DateTime :updated_at
end
