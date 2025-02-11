require "sequel/plugins/serialization"

class User < Sequel::Model
  include GDS::SSO::User

  # GDS SSO expects an ActiveRecord model, but we're using Sequel so we have to disguise
  # our model as an ActiveRecord model a bit:
  alias_method :remotely_signed_out?, :remotely_signed_out
  alias_method :update!, :update
  alias_method :save!, :save
  class << self
    alias_method :create!, :create
  end

  # This is roughly equivalent to ActiveRecord's `serialize :permissions, Array`
  plugin :serialization, :yaml, :permissions

  def update_attribute(attribute, value)
    update(attribute => value)
  end
end
