require "csv"

desc "Generate queries for each of the schemas in the editions table, based on some random example items"
task suggest_queries: :environment do
  # with editions as (
  #   select
  #     schema_name,
  #     base_path,
  #     row_number() over (partition by schema_name order by random()) as row_number
  #   from editions
  #   join documents on documents.id = editions.document_id
  #   where state='published' and locale='en' and base_path is not null and schema_name not in ('gone', 'redirect')
  #   order by schema_name
  # )
  # select * from editions where row_number < 5;
  csv_data = <<~CSV
    answer,/report-domestic-abuse,1
    answer,/company-director-disqualification,2
    answer,/expenses-and-benefits-employee-suggestion-schemes,3
    answer,/set-up-free-school,4
    calendar,/bank-holidays,1
    calendar,/when-do-the-clocks-change,2
    call_for_evidence,/government/calls-for-evidence/building-a-market-for-energy-efficiency-call-for-evidence,1
    call_for_evidence,/government/calls-for-evidence/cyber-security-organisational-standards-call-for-evidence,2
    call_for_evidence,/government/calls-for-evidence/strengthening-the-uks-offshore-oil-and-gas-decommissioning-industry-call-for-evidence,3
    call_for_evidence,/government/calls-for-evidence/improving-integrated-commissioning-in-health-and-social-care,4
    case_study,/government/case-studies/carbon-market-finance-cmf,1
    case_study,/government/case-studies/20-million-investment-for-sports-and-leisure-in-forest-of-dean,2
    case_study,/government/case-studies/avid-saving-fuel-and-reducing-emissions-from-vehicles,3
    case_study,/government/case-studies/minerva-learning-trust,4
    completed_transaction,/done/prevent-duty-training,1
    completed_transaction,/done/brp-report-lost-stolen,2
    completed_transaction,/done/renewtaxcredits,3
    completed_transaction,/done/update-uk-visas-immigration-account-details,4
    consultation,/government/consultations/introduction-of-a-use-class-for-short-term-lets-and-associated-permitted-development-rights,1
    consultation,/government/consultations/consultation-on-additional-tax-relief-for-visual-effects-costs,2
    consultation,/government/consultations/october-2023-catch-limit-review,3
    consultation,/government/consultations/modern-leasehold-restricting-ground-rent-for-existing-leases,4
    contact,/government/organisations/hm-revenue-customs/contact/get-help-from-hmrc-s-extra-support-team,1
    contact,/government/organisations/hm-revenue-customs/contact/employers-how-to-confirm-an-employee-tax-code,2
    contact,/government/organisations/hm-revenue-customs/contact/construction-industry-scheme,3
    contact,/government/organisations/hm-revenue-customs/contact/secure-data-exchange-service-sdes,4
    coronavirus_landing_page,/coronavirus,1
    corporate_information_page,/government/organisations/trade-and-agriculture-commission/about/terms-of-reference,1
    corporate_information_page,/government/organisations/police-remuneration-review-body/about/accessible-documents-policy,2
    corporate_information_page,/government/organisations/great-british-nuclear/about/personal-information-charter,3
    corporate_information_page,/government/organisations/committee-on-mutagenicity-of-chemicals-in-food-consumer-products-and-the-environment/about/membership,4
    detailed_guide,/guidance/eu-guidance-documents-referred-to-in-the-human-medicines-regulations-2012,1
    detailed_guide,/guidance/tell-ofsted-you-want-to-contract-as-an-inspector,2
    detailed_guide,/guidance/2023-rights-of-way-order-information-start-date-notices-inquiry-hearing-notices-and-rejection-letters,3
    detailed_guide,/guidance/early-years-foundation-stage-exemplification-materials,4
    document_collection,/government/collections/health-protection-report-latest-infection-reports,1
    document_collection,/government/collections/hs2-plan-and-profile-maps-between-london-and-the-west-midlands,2
    document_collection,/government/collections/daily-mail-and-general-trust-plc-dmgt-acquisition-of-jpi-media-publications-limited,3
    document_collection,/government/collections/ssac-foi-releases,4
    email_alert_signup,/foreign-travel-advice/zambia/email-signup,1
    email_alert_signup,/foreign-travel-advice/central-african-republic/email-signup,2
    email_alert_signup,/foreign-travel-advice/singapore/email-signup,3
    email_alert_signup,/foreign-travel-advice/curacao/email-signup,4
    embassies_index,/world/embassies,1
    fatality_notice,/government/fatalities/marine-damian-davies-sergeant-john-manuel-and-corporal-marc-birch-killed-in-afghanistan,1
    fatality_notice,/government/fatalities/private-jason-george-williams-killed-in-afghanistan,2
    fatality_notice,/government/fatalities/flight-sergeant-gary-wayne-andrews-killed-in-afghanistan,3
    fatality_notice,/government/fatalities/lieutenant-antony-king,4
    field_of_operation,/government/fields-of-operation/other-locations,1
    field_of_operation,/government/fields-of-operation/northern-ireland,2
    field_of_operation,/government/fields-of-operation/afghanistan,3
    field_of_operation,/government/fields-of-operation/united-kingdom,4
    fields_of_operation,/government/fields-of-operation,1
    finder,/flood-and-coastal-erosion-risk-management-research-reports,1
    finder,/find-digital-market-research,2
    finder,/ai-assurance-techniques,3
    finder,/marine-equipment-approved-recommendations,4
    finder_email_signup,/tax-and-chancery-tribunal-decisions/email-signup,1
    finder_email_signup,/cma-cases/email-signup,2
    finder_email_signup,/search/transparency-and-freedom-of-information-releases/email-signup,3
    finder_email_signup,/animal-disease-cases-england/email-signup,4
    generic,/government/organisations/charity-commission/services-information,1
    get_involved,/government/get-involved,1
    government,/government/1910-to-1910-liberal-minority-government,1
    government,/government/1841-to-1847-conservative-government,2
    government,/government/1900-to-1906-conservative-government,3
    government,/government/1951-to-1955-conservative-government,4
    guide,/global-talent-researcher-academic,1
    guide,/unclaimed-estates-bona-vacantia,2
    guide,/appeal-planning-decision,3
    guide,/penalty-points-endorsements,4
    help_page,/help/get-emails-about-updates-to-govuk,1
    help_page,/help/privacy-notice,2
    help_page,/help/about-govuk,3
    help_page,/help/browsers,4
    historic_appointment,/government/history/past-prime-ministers/andrew-bonar-law,1
    historic_appointment,/government/history/past-prime-ministers/harold-wilson,2
    historic_appointment,/government/history/past-prime-ministers/william-ewart-gladstone,3
    historic_appointment,/government/history/past-prime-ministers/david-cameron,4
    historic_appointments,/government/history/past-prime-ministers,1
    history,/government/history/king-charles-street,1
    history,/government/history/11-downing-street,2
    history,/government/history/10-downing-street,3
    history,/government/history,4
    hmrc_manual,/hmrc-internal-manuals/help-save-technical,1
    hmrc_manual,/hmrc-internal-manuals/paye-settlement-agreements,2
    hmrc_manual,/hmrc-internal-manuals/tonnage-tax-manual,3
    hmrc_manual,/hmrc-internal-manuals/complaints-handling-guidance,4
    hmrc_manual_section,/hmrc-internal-manuals/international-manual/intm413190,1
    hmrc_manual_section,/hmrc-internal-manuals/compliance-operational-guidance/cogupdate141013,2
    hmrc_manual_section,/hmrc-internal-manuals/capital-gains-manual/cg51825,3
    hmrc_manual_section,/hmrc-internal-manuals/corporate-intangibles-research-and-development-manual/cird10120,4
    homepage,/,1
    how_government_works,/government/how-government-works,1
    html_publication,/government/publications/monkeypox-outbreak-epidemiological-overview/monkeypox-outbreak-epidemiological-overview-29-july-2022,1
    html_publication,/government/publications/procurement-at-fcdo-procurement-act-2023/procurement-at-fcdo-procurement-act-2023,2
    html_publication,/government/publications/g7-foreign-and-development-ministers-meeting-11-12-december-2021-chairs-statements/63482227-af78-45fc-9b4e-a16a4fb88d72,3
    html_publication,/government/publications/2010-to-2015-government-policy-deficit-reduction/2010-to-2015-government-policy-deficit-reduction,4
    landing_page,/missions/opportunity,1
    landing_page,/missions/nhs,2
    landing_page,/missions/clean-energy,3
    landing_page,/missions/strong-foundations,4
    local_transaction,/report-blocked-drain,1
    local_transaction,/report-graffiti,2
    local_transaction,/report-road-flooding,3
    local_transaction,/report-flytipping,4
    mainstream_browse_page,/browse/childcare-parenting/fostering-adoption-surrogacy,1
    mainstream_browse_page,/browse/business/setting-up,2
    mainstream_browse_page,/browse/working/finding-job,3
    mainstream_browse_page,/browse/employing-people/contracts,4
    manual,/guidance/childminders-and-childcare-providers-register-with-ofsted,1
    manual,/guidance/the-trader-s-guide-to-importing-and-exporting-certain-agricultural-goods,2
    manual,/guidance/chemical-waste-appropriate-measures-for-permitted-facilities,3
    manual,/guidance/land-compensation-manual-section-17-references-to-the-upper-tribunal-land-chamber,4
    manual_section,/guidance/rating-manual-section-6-part-3-valuation-of-all-property-classes/section-640-marinas,1
    manual_section,/guidance/qualifications-funding-approval-manual-2025-to-2026/scope-of-this-qualification-funding-approval-manual,2
    manual_section,/guidance/vat-tertiary-legislation/northern-ireland,3
    manual_section,/guidance/rating-manual-section-6-chhallenges-to-the-rating-list/part-4-pre-cca-england-and-wales,4
    ministers_index,/government/ministers,1
    news_article,/government/news/davie-appointed-new-chair-of-creative-industries-council,1
    news_article,/government/news/statement-on-disturbance-at-hmp-ford,2
    news_article,/government/news/funding-boost-will-provide-200000-homes-on-brownfield-land,3
    news_article,/government/news/visit-to-chile-by-foreign-secretary-boris-johnson,4
    organisation,/government/organisations/high-speed-two-limited,1
    organisation,/government/organisations/office-of-the-first-minister-and-deputy-first-minister,2
    organisation,/government/organisations/scotland-office,3
    organisation,/government/organisations/defence-analytical-services-agency,4
    organisations_homepage,/government/organisations,1
    person,/government/people/geth-williams,1
    person,/government/people/anwar-choudhury,2
    person,/government/people/peter-wilson,3
    person,/government/people/matthew-kidd,4
    place,/find-adr-training,1
    place,/disabled-students-allowances-assessment-centre,2
    place,/register-offices,3
    place,/report-child-abuse-to-local-council,4
    placeholder_corporate_information_page,/world/organisations/uk-science-innovation-network-in-croatia/about/about,1
    placeholder_corporate_information_page,/world/organisations/uk-science-innovation-network-in-slovenia/about/about,2
    placeholder_corporate_information_page,/world/organisations/uk-science-innovation-network-in-bahrain/about/about,3
    placeholder_corporate_information_page,/world/organisations/uk-science-and-innovation-network-in-oman/about/about,4
    publication,/government/statistics/steps-2-success-ni-statistics-from-october-2014-to-september-2020,1
    publication,/government/statistics/ambulance-quality-indicators-systems-indicators-for-june-2020,2
    publication,/government/publications/charity-reporting-and-accounting-rs21,3
    publication,/government/publications/application-to-the-traffic-commissioner-for-the-return-of-detained-vehicle-k66paf,4
    role,/government/ministers/parliamentary-under-secretary-of-state--24,1
    role,/government/ministers/parliamentary-under-secretary-of-state--101,2
    role,/government/ministers/parliamentary-under-secretary-of-state--58,3
    role,/government/ministers/parliamentary-under-secretary-of-state--59,4
    service_manual_guide,/service-manual/technology/testing-with-assistive-technologies,1
    service_manual_guide,/service-manual/agile-delivery/how-the-beta-phase-works,2
    service_manual_guide,/service-manual/user-research/find-user-research-participants,3
    service_manual_guide,/service-manual/design/govuk-content-transactions,4
    service_manual_homepage,/service-manual,1
    service_manual_service_standard,/service-manual/service-standard,1
    service_manual_service_toolkit,/service-toolkit,1
    service_manual_topic,/service-manual/design,1
    service_manual_topic,/service-manual/support,2
    service_manual_topic,/service-manual/the-team,3
    service_manual_topic,/service-manual/user-research,4
    service_sign_in,/claim-rural-payments/sign-in,1
    simple_smart_answer,/register-for-self-assessment,1
    simple_smart_answer,/return-or-contact-abducted-child,2
    simple_smart_answer,/sold-bought-vehicle,3
    simple_smart_answer,/which-court-or-tribunal-to-appeal-to,4
    smart_answer,/calculate-employee-redundancy-pay,1
    smart_answer,/report-a-lost-or-stolen-passport,2
    smart_answer,/vat-payment-deadlines,3
    smart_answer,/plan-adoption-leave,4
    special_route,/api/content,1
    special_route,/sitemap.xml,2
    special_route,/search/advanced,3
    special_route,/account/cookies-and-feedback,4
    specialist_document,/employment-tribunal-decisions/miss-m-perkins-v-extran-medica-ltd-3332499-2018,1
    specialist_document,/residential-property-tribunal-decisions/vogans-mill-17-mill-street-london-se1-2bz-lon-00be-ldc-2019-0058,2
    specialist_document,/employment-tribunal-decisions/mr-i-ghezali-v-cup-glasgow-ltd-4122849-2018,3
    specialist_document,/research-for-development-outputs/consensus-for-a-holistic-approach-to-improve-rural-livelihoods-in-riverine-islands-of-bangladesh-scientific-report,4
    speech,/government/speeches/delivering-long-term-stability-to-the-sahel-region,1
    speech,/government/speeches/speech-to-the-british-irish-association-conference,2
    speech,/government/speeches/speech-by-jeremy-browne-mp-on-female-genital-mutilation,3
    speech,/government/speeches/2010-07-22-ads-charity-dinner-in-support-of-ssafa-forces-help,4
    statistical_data_set,/government/statistical-data-sets/repi-transport,1
    statistical_data_set,/government/statistical-data-sets/monthly-management-information-ofsteds-further-education-and-skills-inspections-outcomes,2
    statistical_data_set,/government/statistical-data-sets/effort-statistics-december-2018,3
    statistical_data_set,/government/statistical-data-sets/banana-prices,4
    statistics_announcement,/government/statistics/announcements/hes-mhld-data-linkage-report-summary-statistics-june-2015,1
    statistics_announcement,/government/statistics/announcements/mandatory-surveillance-of-mrsa-mssa-and-escherichia-coli-bacteraemia-and-clostridium-difficile-infection-july-2014-to-july-2015,2
    statistics_announcement,/government/statistics/announcements/adult-social-care-in-england-may-2021,3
    statistics_announcement,/government/statistics/announcements/provisional-monthly-patient-reported-outcome-measures-proms-in-england-april-2016-to-july-2016,4
    step_by_step_nav,/apply-parent-child-student-visa,1
    step_by_step_nav,/import-goods-into-uk,2
    step_by_step_nav,/vote-uk-election,3
    step_by_step_nav,/get-a-divorce,4
    take_part,/government/get-involved/take-part/challenge-to-run-a-local-service,1
    take_part,/government/get-involved/take-part/take-over-a-local-pub-shop-or-green-space-for-the-community,2
    take_part,/government/get-involved/take-part/improve-your-social-housing,3
    take_part,/government/get-involved/take-part/set-up-a-town-or-parish-council,4
    taxon,/world/travelling-to-south-africa,1
    taxon,/world/coming-to-the-uk-togo,2
    taxon,/world/tax-benefits-pensions-and-working-abroad-venezuela,3
    taxon,/world/travelling-to-new-zealand,4
    topical_event,/government/topical-events/vjday70,1
    topical_event,/government/topical-events/budget-2015,2
    topical_event,/government/topical-events/open-government-partnership-summit-2013,3
    topical_event,/government/topical-events/nato-summit-wales-cymru-2014,4
    topical_event_about_page,/government/topical-events/national-apprenticeship-awards/about,1
    topical_event_about_page,/government/topical-events/global-conference-for-media-freedom-london-2019/about,2
    topical_event_about_page,/government/topical-events/ai-safety-summit-2023/about,3
    topical_event_about_page,/government/topical-events/uk-voluntary-national-review-of-progress-towards-the-sustainable-development-goals-2018/about,4
    transaction,/trade-tariff,1
    transaction,/make-a-sorn,2
    transaction,/record-delegated-driving-test-details,3
    transaction,/check-legal-aid,4
    travel_advice,/foreign-travel-advice/maldives,1
    travel_advice,/foreign-travel-advice/guatemala,2
    travel_advice,/foreign-travel-advice/cambodia,3
    travel_advice,/foreign-travel-advice/chad,4
    travel_advice_index,/foreign-travel-advice,1
    working_group,/government/groups/global-travel-taskforce,1
    working_group,/government/groups/pilot,2
    working_group,/government/groups/secretary-of-state-for-transports-honorary-medical-advisory-panel-on-alcohol-drugs-and-substance-misuse-and-driving,3
    working_group,/government/groups/scientific-advisory-group-on-chemical-safety-in-consumer-products,4
    world_index,/world,1
    world_location_news,/world/romania/news,1
    world_location_news,/world/mongolia/news,2
    world_location_news,/world/st-kitts-and-nevis/news,3
    world_location_news,/world/zambia/news,4
    worldwide_corporate_information_page,/world/organisations/british-embassy-dublin/about/recruitment,1
    worldwide_corporate_information_page,/world/organisations/british-embassy-conakry/about/complaints-procedure,2
    worldwide_corporate_information_page,/world/organisations/british-embassy-amman/about/complaints-procedure,3
    worldwide_corporate_information_page,/world/organisations/british-embassy-vientiane/about/complaints-procedure,4
    worldwide_office,/world/organisations/british-deputy-high-commission-hyderabad/office/british-deputy-high-commission-hyderabad,1
    worldwide_office,/world/organisations/british-embassy-pristina/office/visa-section,2
    worldwide_office,/world/organisations/department-for-business-and-trade-united-arab-emirates/office/uk-trade-investment-abu-dhabi,3
    worldwide_office,/world/organisations/british-embassy-lisbon/office/department-for-business-and-trade,4
    worldwide_organisation,/world/organisations/british-embassy-harare,1
    worldwide_organisation,/world/organisations/british-embassy-dubai,2
    worldwide_organisation,/world/organisations/british-defence-staff-in-the-usa,3
    worldwide_organisation,/world/organisations/british-high-commission-castries,4
  CSV
  csv = CSV.parse(csv_data)
  query = <<~GRAPHQL
    query suggest($base_path: String!) {
      suggest_query(base_path: $base_path, use_fragments: true)
    }
  GRAPHQL
  csv.group_by { |row| row[0] }.each_value do |rows|
    schema_name, base_path, = rows.first
    begin
      result = GovukGraphqlSchema.execute(query, variables: { base_path: base_path })
      File.open(Rails.root.join("app/graphql/queries/#{schema_name}.graphql.erb"), "w") do |file|
        file.write <<~ERB
          <%#
          Examples:
          - #{rows.map { |_, bp,| "https://www.gov.uk#{bp}" }.join("\n- ")}
          %>

          #{result.to_h.dig('data', 'suggest_query')}
        ERB
      end
    rescue StandardError => e
      puts "Failed to suggest query for #{schema_name} with base_path #{base_path} - #{e}"
    end
  end
end
