class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  before_action :authenticate_user!

protected

  def set_prometheus_labels(schema_name:, locale:)
    prometheus_labels = request.env.fetch("govuk.prometheus_labels", {})
    request.env["govuk.prometheus_labels"] = prometheus_labels.merge(schema_name:, locale:)
  end

  def disable_gc
    GC.disable
    yield
  ensure
    GC.enable
  end
end
