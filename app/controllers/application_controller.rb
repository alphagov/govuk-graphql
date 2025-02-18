class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  before_action :authenticate_user!

protected

  def set_prometheus_labels(schema_name)
    prometheus_labels = request.env.fetch("govuk.prometheus_labels", {})
    request.env["govuk.prometheus_labels"] = prometheus_labels.merge(schema_name: schema_name)
  end
end
