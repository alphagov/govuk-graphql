source "https://rubygems.org"

gem "rails", "~> 8.0.2"

gem "graphql", "~> 2.5"

gem "bootsnap", require: false
gem "content_block_tools", "~> 0.17"
gem "gds-api-adapters", "~> 99.3"
gem "gds-sso", "~> 20.0"
gem "govspeak", "~> 10.6"
gem "govuk_app_config", "~> 9.20"
gem "hashdiff", "~> 1.2"
gem "memo_wise", "~> 1.13"
gem "pg", "~> 1.6"
gem "sequel", "~> 5.97"
gem "sequel_pg", "~> 1.17", require: "sequel"
gem "sequel-rails", "~> 1.2"

gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  gem "csv"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  gem "rubocop-govuk", "~> 5.1", require: false

  gem "rack-mini-profiler", "~> 4.0"
  gem "stackprof", "~> 0.2.27"

  # Needed by RubyMine
  gem "mutex_m", require: false
end
