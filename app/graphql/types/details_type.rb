module Types
  class DetailsType < Types::BaseObject
    # TODO: - make these fields more specific, instead of always JSON
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

    field :body, String, null: true
    def body = process_body(object[:body])

    field :born, GraphQL::Types::JSON, null: true
    field :brand, GraphQL::Types::JSON, null: true
    field :breadcrumbs, GraphQL::Types::JSON, null: true
    field :cancellation_reason, GraphQL::Types::JSON, null: true
    field :cancelled_at, GraphQL::Types::JSON, null: true
    field :casualties, GraphQL::Types::JSON, null: true
    field :change_description, GraphQL::Types::JSON, null: true

    field :change_history, GraphQL::Types::JSON, null: true
    def change_history
      return object[:change_history] if object[:change_history]

      change_notes = Sequel[:change_notes]
      editions = Sequel[:editions]

      parent = object[:parent]
      return nil if parent.nil?

      document_id, user_facing_version = parent.values_at(:document_id, :user_facing_version)
      return nil if document_id.nil? || user_facing_version.nil?

      Sequel::Model.db[change_notes]
        .join(editions, id: change_notes[:edition_id])
        .where(editions[:document_id] => document_id)
        .where(Sequel[:user_facing_version] => ..user_facing_version)
        .where { change_notes[:public_timestamp] !~ nil }
        .order(change_notes[:public_timestamp])
        .select(:note, :public_timestamp)
    end

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
    def introductory_paragraph = process_body(object[:introductory_paragraph])

    field :introductory_paragraph_ast, GraphQL::Types::JSON, null: true
    def introductory_paragraph_ast
      intro_para = object[:introductory_paragraph]
      return nil unless intro_para
      raise "Unexpected body format: #{intro_para.class}" unless intro_para.is_a?(Array)

      govspeak_doc = case intro_para.map(&:deep_symbolize_keys)
                     in [*, { content_type: "text/govspeak", content: String => body }, *]
                       Govspeak::Document.new(body, {
                         attachments: object[:attachments],
                         locale: object.dig(:parent, :locale),
                       })
                     end

      govspeak_doc.send(:kramdown_doc).as_json.dig("root", "children").map(&method(:compact_and_select_kramdown_fields))
    end

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
    def parts
      object[:parts]&.map do |part|
        part.merge("body" => process_body(part["body"]))
      end
    end
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

    field :json, GraphQL::Types::JSON, null: false
    def json = object

  private

    def process_body(body)
      return nil unless body
      return body if body.is_a?(String)
      raise "Unexpected body format: #{body.class}" unless body.is_a?(Array)

      html = case body.map(&:deep_symbolize_keys)
             in [*, { content_type: "text/html", content: String => body }, *]
               body
             in [*, { content_type: "text/govspeak", content: String => body }, *]
               Govspeak::Document.new(body, {
                 attachments: object[:attachments],
                 locale: object.dig(:parent, :locale),
               }).to_html
             end

      embeds = object.dig(:parent, :links, "embed")
      return html if embeds.blank?

      references = ContentBlockTools::ContentBlockReference.find_all_in_document(html)
      references.uniq.each do |ref|
        embed_code = ref.embed_code
        embed = embeds.find { it[:content_id] == ref.content_id }
        next if embed.nil?

        Rails.logger.info("Rendering embed #{embed}")
        content_block = ContentBlockTools::ContentBlock.new(
          document_type: embed[:document_type],
          content_id: embed[:content_id],
          title: embed[:title],
          details: embed[:details],
          embed_code: embed_code,
        )

        html.gsub!(embed_code, content_block.render)
      end
      html
    end

    def compact_and_select_kramdown_fields(hash)
      return if hash.nil?

      allowed_keys = %w[attr value type children]

      selected_hash = hash.select { |key,| allowed_keys.include?(key) }.transform_values do |value|
        case value
        in {}
          nil
        in []
          nil
        in Hash
          compact_and_select_kramdown_fields(value)
        in Array
          value.map { |child| compact_and_select_kramdown_fields(child) }
        else
          value
        end
      end

      selected_hash.compact
    end
  end
end
