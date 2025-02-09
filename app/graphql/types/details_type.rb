module Types
  class DetailsType < Types::BaseObject
    # TODO - make these fields more specific, instead of always JSON
    field :about_page_link_text, GraphQL::Types::JSON, null: true
    field :access_and_opening_times, GraphQL::Types::JSON, null: true
    field :acronym, GraphQL::Types::JSON, null: true
    field :alert_status, GraphQL::Types::JSON, null: true
    field :alternative_format_contact_email, GraphQL::Types::JSON, null: true
    field :appointments_without_historical_accounts, GraphQL::Types::JSON, null: true
    field :attachments, GraphQL::Types::JSON, null: true
    field :attends_cabinet_type, GraphQL::Types::JSON, null: true
    field :beta, GraphQL::Types::JSON, null: true
    field :beta_message, GraphQL::Types::JSON, null: true
    field :blocks, GraphQL::Types::JSON, null: true
    field :body, GraphQL::Types::JSON, null: true
    field :born, GraphQL::Types::JSON, null: true
    field :brand, GraphQL::Types::JSON, null: true
    field :breadcrumbs, GraphQL::Types::JSON, null: true
    field :cancellation_reason, GraphQL::Types::JSON, null: true
    field :cancelled_at, GraphQL::Types::JSON, null: true
    field :casualties, GraphQL::Types::JSON, null: true
    field :change_description, GraphQL::Types::JSON, null: true
    field :change_history, GraphQL::Types::JSON, null: true
    field :change_note, GraphQL::Types::JSON, null: true
    field :change_notes, GraphQL::Types::JSON, null: true
    field :child_section_groups, GraphQL::Types::JSON, null: true
    field :choose_sign_in, GraphQL::Types::JSON, null: true
    field :closing_date, GraphQL::Types::JSON, null: true
    field :collection_groups, GraphQL::Types::JSON, null: true
    field :collections, GraphQL::Types::JSON, null: true
    field :combine_mode, GraphQL::Types::JSON, null: true
    field :contact_form_links, GraphQL::Types::JSON, null: true
    field :contact_groups, GraphQL::Types::JSON, null: true
    field :contact_type, GraphQL::Types::JSON, null: true
    field :corporate_information_groups, GraphQL::Types::JSON, null: true
    field :country, GraphQL::Types::JSON, null: true
    field :current, GraphQL::Types::JSON, null: true
    field :dates_in_office, GraphQL::Types::JSON, null: true
    field :default_documents_per_page, GraphQL::Types::JSON, null: true
    field :default_news_image, GraphQL::Types::JSON, null: true
    field :default_order, GraphQL::Types::JSON, null: true
    field :delivered_on, GraphQL::Types::JSON, null: true
    field :department_analytics_profile, GraphQL::Types::JSON, null: true
    field :department_counts, GraphQL::Types::JSON, null: true
    field :description, GraphQL::Types::JSON, null: true
    field :died, GraphQL::Types::JSON, null: true
    field :display_as_result_metadata, GraphQL::Types::JSON, null: true
    field :display_date, GraphQL::Types::JSON, null: true
    field :document, GraphQL::Types::JSON, null: true
    field :document_noun, GraphQL::Types::JSON, null: true
    field :documents, GraphQL::Types::JSON, null: true
    field :email, GraphQL::Types::JSON, null: true
    field :email_address, GraphQL::Types::JSON, null: true
    field :email_addresses, GraphQL::Types::JSON, null: true
    field :email_filter_by, GraphQL::Types::JSON, null: true
    field :email_filter_facets, GraphQL::Types::JSON, null: true
    field :email_signup_link, GraphQL::Types::JSON, null: true
    field :emphasised_organisations, GraphQL::Types::JSON, null: true
    field :end_date, GraphQL::Types::JSON, null: true
    field :ended_on, GraphQL::Types::JSON, null: true
    field :external_related_links, GraphQL::Types::JSON, null: true
    field :facets, GraphQL::Types::JSON, null: true
    field :featured_attachments, GraphQL::Types::JSON, null: true
    field :filter, GraphQL::Types::JSON, null: true
    field :filter_key, GraphQL::Types::JSON, null: true
    field :filterable, GraphQL::Types::JSON, null: true
    field :final_outcome_attachments, GraphQL::Types::JSON, null: true
    field :final_outcome_detail, GraphQL::Types::JSON, null: true
    field :final_outcome_documents, GraphQL::Types::JSON, null: true
    field :first_public_at, GraphQL::Types::JSON, null: true
    field :first_published_version, GraphQL::Types::JSON, null: true
    field :foi_exempt, GraphQL::Types::JSON, null: true
    field :format_display_type, GraphQL::Types::JSON, null: true
    field :format_name, GraphQL::Types::JSON, null: true
    field :format_sub_type, GraphQL::Types::JSON, null: true
    field :full_name, GraphQL::Types::JSON, null: true
    field :govdelivery_title, GraphQL::Types::JSON, null: true
    field :government, GraphQL::Types::JSON, null: true
    field :groups, GraphQL::Types::JSON, null: true
    field :header_links, GraphQL::Types::JSON, null: true
    field :header_section, GraphQL::Types::JSON, null: true
    field :headers, GraphQL::Types::JSON, null: true
    field :headings, GraphQL::Types::JSON, null: true
    field :held_on_another_website_url, GraphQL::Types::JSON, null: true
    field :hidden_search_terms, GraphQL::Types::JSON, null: true
    field :hide_chapter_navigation, GraphQL::Types::JSON, null: true
    field :image, GraphQL::Types::JSON, null: true
    field :important_board_members, GraphQL::Types::JSON, null: true
    field :interesting_facts, GraphQL::Types::JSON, null: true
    field :internal_name, GraphQL::Types::JSON, null: true
    field :international_delegations, GraphQL::Types::JSON, null: true
    field :introduction, GraphQL::Types::JSON, null: true
    field :introductory_paragraph, GraphQL::Types::JSON, null: true
    field :key, GraphQL::Types::JSON, null: true
    field :label, GraphQL::Types::JSON, null: true
    field :label_text, GraphQL::Types::JSON, null: true
    field :language, GraphQL::Types::JSON, null: true
    field :latest_change_note, GraphQL::Types::JSON, null: true
    field :lgil_code, GraphQL::Types::JSON, null: true
    field :lgsl_code, GraphQL::Types::JSON, null: true
    field :link_items, GraphQL::Types::JSON, null: true
    field :location, GraphQL::Types::JSON, null: true
    field :logo, GraphQL::Types::JSON, null: true
    field :major_acts, GraphQL::Types::JSON, null: true
    field :manual, GraphQL::Types::JSON, null: true
    field :mapped_specialist_topic_content_id, GraphQL::Types::JSON, null: true
    field :max_cache_time, GraphQL::Types::JSON, null: true
    field :metadata, GraphQL::Types::JSON, null: true
    field :ministerial_role_counts, GraphQL::Types::JSON, null: true
    field :mission_statement, GraphQL::Types::JSON, null: true
    field :more_info_contact_form, GraphQL::Types::JSON, null: true
    field :more_info_email_address, GraphQL::Types::JSON, null: true
    field :more_info_phone_number, GraphQL::Types::JSON, null: true
    field :more_info_post_address, GraphQL::Types::JSON, null: true
    field :more_info_webchat, GraphQL::Types::JSON, null: true
    field :more_information, GraphQL::Types::JSON, null: true
    field :name, GraphQL::Types::JSON, null: true
    field :national_applicability, GraphQL::Types::JSON, null: true
    field :navigation_groups, GraphQL::Types::JSON, null: true
    field :need_to_know, GraphQL::Types::JSON, null: true
    field :nodes, GraphQL::Types::JSON, null: true
    field :northern_ireland_availability, GraphQL::Types::JSON, null: true
    field :notes_for_editors, GraphQL::Types::JSON, null: true
    field :office_contact_associations, GraphQL::Types::JSON, null: true
    field :open_filter_on_load, GraphQL::Types::JSON, null: true
    field :opening_date, GraphQL::Types::JSON, null: true
    field :ordered_agencies_and_other_public_bodies, GraphQL::Types::JSON, null: true
    field :ordered_corporate_information_pages, GraphQL::Types::JSON, null: true
    field :ordered_devolved_administrations, GraphQL::Types::JSON, null: true
    field :ordered_executive_offices, GraphQL::Types::JSON, null: true
    field :ordered_featured_documents, GraphQL::Types::JSON, null: true
    field :ordered_featured_links, GraphQL::Types::JSON, null: true
    field :ordered_high_profile_groups, GraphQL::Types::JSON, null: true
    field :ordered_ministerial_departments, GraphQL::Types::JSON, null: true
    field :ordered_non_ministerial_departments, GraphQL::Types::JSON, null: true
    field :ordered_promotional_features, GraphQL::Types::JSON, null: true
    field :ordered_public_corporations, GraphQL::Types::JSON, null: true
    field :ordered_second_level_browse_pages, GraphQL::Types::JSON, null: true
    field :ordering, GraphQL::Types::JSON, null: true
    field :organisation, GraphQL::Types::JSON, null: true
    field :organisation_featuring_priority, GraphQL::Types::JSON, null: true
    field :organisation_govuk_status, GraphQL::Types::JSON, null: true
    field :organisation_political, GraphQL::Types::JSON, null: true
    field :organisation_type, GraphQL::Types::JSON, null: true
    field :organisations, GraphQL::Types::JSON, null: true
    field :other_ways_to_apply, GraphQL::Types::JSON, null: true
    field :outcome_attachments, GraphQL::Types::JSON, null: true
    field :outcome_detail, GraphQL::Types::JSON, null: true
    field :outcome_documents, GraphQL::Types::JSON, null: true
    field :parts, GraphQL::Types::JSON, null: true
    field :people_role_associations, GraphQL::Types::JSON, null: true
    field :person_appointment_order, GraphQL::Types::JSON, null: true
    field :phone_numbers, GraphQL::Types::JSON, null: true
    field :place_type, GraphQL::Types::JSON, null: true
    field :political, GraphQL::Types::JSON, null: true
    field :political_party, GraphQL::Types::JSON, null: true
    field :post_addresses, GraphQL::Types::JSON, null: true
    field :preposition, GraphQL::Types::JSON, null: true
    field :previous_display_date, GraphQL::Types::JSON, null: true
    field :privy_counsellor, GraphQL::Types::JSON, null: true
    field :promotion, GraphQL::Types::JSON, null: true
    field :public_feedback_attachments, GraphQL::Types::JSON, null: true
    field :public_feedback_detail, GraphQL::Types::JSON, null: true
    field :public_feedback_documents, GraphQL::Types::JSON, null: true
    field :public_feedback_publication_date, GraphQL::Types::JSON, null: true
    field :public_timestamp, GraphQL::Types::JSON, null: true
    field :query_response_time, GraphQL::Types::JSON, null: true
    field :quick_links, GraphQL::Types::JSON, null: true
    field :read_more, GraphQL::Types::JSON, null: true
    field :reject, GraphQL::Types::JSON, null: true
    field :related_mainstream_content, GraphQL::Types::JSON, null: true
    field :reshuffle_in_progress, GraphQL::Types::JSON, null: true
    field :reviewed_at, GraphQL::Types::JSON, null: true
    field :role_payment_type, GraphQL::Types::JSON, null: true
    field :roll_call_introduction, GraphQL::Types::JSON, null: true
    field :second_level_ordering, GraphQL::Types::JSON, null: true
    field :secondary_corporate_information_pages, GraphQL::Types::JSON, null: true
    field :section_id, GraphQL::Types::JSON, null: true
    field :sections, GraphQL::Types::JSON, null: true
    field :seniority, GraphQL::Types::JSON, null: true
    field :service_tiers, GraphQL::Types::JSON, null: true
    field :services, GraphQL::Types::JSON, null: true
    field :short_name, GraphQL::Types::JSON, null: true
    field :show_description, GraphQL::Types::JSON, null: true
    field :show_summaries, GraphQL::Types::JSON, null: true
    field :signup_link, GraphQL::Types::JSON, null: true
    field :slug, GraphQL::Types::JSON, null: true
    field :social_media_links, GraphQL::Types::JSON, null: true
    field :sort, GraphQL::Types::JSON, null: true
    field :speaker_without_profile, GraphQL::Types::JSON, null: true
    field :speech_type_explanation, GraphQL::Types::JSON, null: true
    field :start_button_text, GraphQL::Types::JSON, null: true
    field :start_date, GraphQL::Types::JSON, null: true
    field :started_on, GraphQL::Types::JSON, null: true
    field :state, GraphQL::Types::JSON, null: true
    field :step_by_step_nav, GraphQL::Types::JSON, null: true
    field :subscriber_list, GraphQL::Types::JSON, null: true
    field :subscription_list_title_prefix, GraphQL::Types::JSON, null: true
    field :summary, GraphQL::Types::JSON, null: true
    field :supports_historical_accounts, GraphQL::Types::JSON, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :temporary_update_type, GraphQL::Types::JSON, null: true
    field :theme, GraphQL::Types::JSON, null: true
    field :title, GraphQL::Types::JSON, null: true
    field :transaction_start_link, GraphQL::Types::JSON, null: true
    field :type, GraphQL::Types::JSON, null: true
    field :updated_at, GraphQL::Types::JSON, null: true
    field :url, GraphQL::Types::JSON, null: true
    field :url_override, GraphQL::Types::JSON, null: true
    field :value, GraphQL::Types::JSON, null: true
    field :variants, GraphQL::Types::JSON, null: true
    field :visible_to_departmental_editors, GraphQL::Types::JSON, null: true
    field :visually_collapsed, GraphQL::Types::JSON, null: true
    field :visually_expanded, GraphQL::Types::JSON, null: true
    field :ways_to_respond, GraphQL::Types::JSON, null: true
    field :what_you_need_to_know, GraphQL::Types::JSON, null: true
    field :whip_organisation, GraphQL::Types::JSON, null: true
    field :will_continue_on, GraphQL::Types::JSON, null: true
    field :world_location_names, GraphQL::Types::JSON, null: true
    field :world_location_news_type, GraphQL::Types::JSON, null: true
    field :world_locations, GraphQL::Types::JSON, null: true

    def about_page_link_text = object["about_page_link_text"]
    def access_and_opening_times = object["access_and_opening_times"]
    def acronym = object["acronym"]
    def alert_status = object["alert_status"]
    def alternative_format_contact_email = object["alternative_format_contact_email"]
    def appointments_without_historical_accounts = object["appointments_without_historical_accounts"]
    def attachments = object["attachments"]
    def attends_cabinet_type = object["attends_cabinet_type"]
    def beta = object["beta"]
    def beta_message = object["beta_message"]
    def blocks = object["blocks"]
    def body = object["body"]
    def born = object["born"]
    def brand = object["brand"]
    def breadcrumbs = object["breadcrumbs"]
    def cancellation_reason = object["cancellation_reason"]
    def cancelled_at = object["cancelled_at"]
    def casualties = object["casualties"]
    def change_description = object["change_description"]
    def change_history = object["change_history"]
    def change_note = object["change_note"]
    def change_notes = object["change_notes"]
    def child_section_groups = object["child_section_groups"]
    def choose_sign_in = object["choose_sign_in"]
    def closing_date = object["closing_date"]
    def collection_groups = object["collection_groups"]
    def collections = object["collections"]
    def combine_mode = object["combine_mode"]
    def contact_form_links = object["contact_form_links"]
    def contact_groups = object["contact_groups"]
    def contact_type = object["contact_type"]
    def corporate_information_groups = object["corporate_information_groups"]
    def country = object["country"]
    def current = object["current"]
    def dates_in_office = object["dates_in_office"]
    def default_documents_per_page = object["default_documents_per_page"]
    def default_news_image = object["default_news_image"]
    def default_order = object["default_order"]
    def delivered_on = object["delivered_on"]
    def department_analytics_profile = object["department_analytics_profile"]
    def department_counts = object["department_counts"]
    def description = object["description"]
    def died = object["died"]
    def display_as_result_metadata = object["display_as_result_metadata"]
    def display_date = object["display_date"]
    def document = object["document"]
    def document_noun = object["document_noun"]
    def documents = object["documents"]
    def email = object["email"]
    def email_address = object["email_address"]
    def email_addresses = object["email_addresses"]
    def email_filter_by = object["email_filter_by"]
    def email_filter_facets = object["email_filter_facets"]
    def email_signup_link = object["email_signup_link"]
    def emphasised_organisations = object["emphasised_organisations"]
    def end_date = object["end_date"]
    def ended_on = object["ended_on"]
    def external_related_links = object["external_related_links"]
    def facets = object["facets"]
    def featured_attachments = object["featured_attachments"]
    def filter = object["filter"]
    def filter_key = object["filter_key"]
    def filterable = object["filterable"]
    def final_outcome_attachments = object["final_outcome_attachments"]
    def final_outcome_detail = object["final_outcome_detail"]
    def final_outcome_documents = object["final_outcome_documents"]
    def first_public_at = object["first_public_at"]
    def first_published_version = object["first_published_version"]
    def foi_exempt = object["foi_exempt"]
    def format_display_type = object["format_display_type"]
    def format_name = object["format_name"]
    def format_sub_type = object["format_sub_type"]
    def full_name = object["full_name"]
    def govdelivery_title = object["govdelivery_title"]
    def government = object["government"]
    def groups = object["groups"]
    def header_links = object["header_links"]
    def header_section = object["header_section"]
    def headers = object["headers"]
    def headings = object["headings"]
    def held_on_another_website_url = object["held_on_another_website_url"]
    def hidden_search_terms = object["hidden_search_terms"]
    def hide_chapter_navigation = object["hide_chapter_navigation"]
    def image = object["image"]
    def important_board_members = object["important_board_members"]
    def interesting_facts = object["interesting_facts"]
    def internal_name = object["internal_name"]
    def international_delegations = object["international_delegations"]
    def introduction = object["introduction"]
    def introductory_paragraph = object["introductory_paragraph"]
    def key = object["key"]
    def label = object["label"]
    def label_text = object["label_text"]
    def language = object["language"]
    def latest_change_note = object["latest_change_note"]
    def lgil_code = object["lgil_code"]
    def lgsl_code = object["lgsl_code"]
    def link_items = object["link_items"]
    def location = object["location"]
    def logo = object["logo"]
    def major_acts = object["major_acts"]
    def manual = object["manual"]
    def mapped_specialist_topic_content_id = object["mapped_specialist_topic_content_id"]
    def max_cache_time = object["max_cache_time"]
    def metadata = object["metadata"]
    def ministerial_role_counts = object["ministerial_role_counts"]
    def mission_statement = object["mission_statement"]
    def more_info_contact_form = object["more_info_contact_form"]
    def more_info_email_address = object["more_info_email_address"]
    def more_info_phone_number = object["more_info_phone_number"]
    def more_info_post_address = object["more_info_post_address"]
    def more_info_webchat = object["more_info_webchat"]
    def more_information = object["more_information"]
    def name = object["name"]
    def national_applicability = object["national_applicability"]
    def navigation_groups = object["navigation_groups"]
    def need_to_know = object["need_to_know"]
    def nodes = object["nodes"]
    def northern_ireland_availability = object["northern_ireland_availability"]
    def notes_for_editors = object["notes_for_editors"]
    def office_contact_associations = object["office_contact_associations"]
    def open_filter_on_load = object["open_filter_on_load"]
    def opening_date = object["opening_date"]
    def ordered_agencies_and_other_public_bodies = object["ordered_agencies_and_other_public_bodies"]
    def ordered_corporate_information_pages = object["ordered_corporate_information_pages"]
    def ordered_devolved_administrations = object["ordered_devolved_administrations"]
    def ordered_executive_offices = object["ordered_executive_offices"]
    def ordered_featured_documents = object["ordered_featured_documents"]
    def ordered_featured_links = object["ordered_featured_links"]
    def ordered_high_profile_groups = object["ordered_high_profile_groups"]
    def ordered_ministerial_departments = object["ordered_ministerial_departments"]
    def ordered_non_ministerial_departments = object["ordered_non_ministerial_departments"]
    def ordered_promotional_features = object["ordered_promotional_features"]
    def ordered_public_corporations = object["ordered_public_corporations"]
    def ordered_second_level_browse_pages = object["ordered_second_level_browse_pages"]
    def ordering = object["ordering"]
    def organisation = object["organisation"]
    def organisation_featuring_priority = object["organisation_featuring_priority"]
    def organisation_govuk_status = object["organisation_govuk_status"]
    def organisation_political = object["organisation_political"]
    def organisation_type = object["organisation_type"]
    def organisations = object["organisations"]
    def other_ways_to_apply = object["other_ways_to_apply"]
    def outcome_attachments = object["outcome_attachments"]
    def outcome_detail = object["outcome_detail"]
    def outcome_documents = object["outcome_documents"]
    def parts = object["parts"]
    def people_role_associations = object["people_role_associations"]
    def person_appointment_order = object["person_appointment_order"]
    def phone_numbers = object["phone_numbers"]
    def place_type = object["place_type"]
    def political = object["political"]
    def political_party = object["political_party"]
    def post_addresses = object["post_addresses"]
    def preposition = object["preposition"]
    def previous_display_date = object["previous_display_date"]
    def privy_counsellor = object["privy_counsellor"]
    def promotion = object["promotion"]
    def public_feedback_attachments = object["public_feedback_attachments"]
    def public_feedback_detail = object["public_feedback_detail"]
    def public_feedback_documents = object["public_feedback_documents"]
    def public_feedback_publication_date = object["public_feedback_publication_date"]
    def public_timestamp = object["public_timestamp"]
    def query_response_time = object["query_response_time"]
    def quick_links = object["quick_links"]
    def read_more = object["read_more"]
    def reject = object["reject"]
    def related_mainstream_content = object["related_mainstream_content"]
    def reshuffle_in_progress = object["reshuffle_in_progress"]
    def reviewed_at = object["reviewed_at"]
    def role_payment_type = object["role_payment_type"]
    def roll_call_introduction = object["roll_call_introduction"]
    def second_level_ordering = object["second_level_ordering"]
    def secondary_corporate_information_pages = object["secondary_corporate_information_pages"]
    def section_id = object["section_id"]
    def sections = object["sections"]
    def seniority = object["seniority"]
    def service_tiers = object["service_tiers"]
    def services = object["services"]
    def short_name = object["short_name"]
    def show_description = object["show_description"]
    def show_summaries = object["show_summaries"]
    def signup_link = object["signup_link"]
    def slug = object["slug"]
    def social_media_links = object["social_media_links"]
    def sort = object["sort"]
    def speaker_without_profile = object["speaker_without_profile"]
    def speech_type_explanation = object["speech_type_explanation"]
    def start_button_text = object["start_button_text"]
    def start_date = object["start_date"]
    def started_on = object["started_on"]
    def state = object["state"]
    def step_by_step_nav = object["step_by_step_nav"]
    def subscriber_list = object["subscriber_list"]
    def subscription_list_title_prefix = object["subscription_list_title_prefix"]
    def summary = object["summary"]
    def supports_historical_accounts = object["supports_historical_accounts"]
    def tags = object["tags"]
    def temporary_update_type = object["temporary_update_type"]
    def theme = object["theme"]
    def title = object["title"]
    def transaction_start_link = object["transaction_start_link"]
    def type = object["type"]
    def updated_at = object["updated_at"]
    def url = object["url"]
    def url_override = object["url_override"]
    def value = object["value"]
    def variants = object["variants"]
    def visible_to_departmental_editors = object["visible_to_departmental_editors"]
    def visually_collapsed = object["visually_collapsed"]
    def visually_expanded = object["visually_expanded"]
    def ways_to_respond = object["ways_to_respond"]
    def what_you_need_to_know = object["what_you_need_to_know"]
    def whip_organisation = object["whip_organisation"]
    def will_continue_on = object["will_continue_on"]
    def world_location_names = object["world_location_names"]
    def world_location_news_type = object["world_location_news_type"]
    def world_locations = object["world_locations"]
  end
end
