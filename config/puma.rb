require "govuk_app_config/govuk_puma"
GovukPuma.configure_rails(self)

before_fork do |_server|
  # Disconnect all databases before forking, otherwise the forked processes
  # will mess up their parent's database connection file descriptors.
  Thread.current[:sequel_connect_options] = Sequel::DATABASES.map do |db|
    db.disconnect
    db.opts[:orig_opts]
  end

  # Copied from GovukPuma.configure_rails
  next unless ENV["GOVUK_APP_ROOT"]

  ENV["BUNDLE_GEMFILE"] = "#{ENV['GOVUK_APP_ROOT']}/Gemfile"
end

on_worker_boot do
  # If the parent of this fork was connected to any databases, reconnect
  Thread.current[:sequel_connect_options].each do |opts|
    Sequel.connect(opts)
  end
end
