Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  get "/api/content/compare(/*base_path)", to: "content_store_shim#compare_content_item"
  get "/api/content(/*base_path)", to: "content_store_shim#content_item"
  get "/query(/*schema_name)", to: "content_store_shim#query"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "graphql#graphiql"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response
end
