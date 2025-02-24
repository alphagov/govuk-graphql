# frozen_string_literal: true

require "benchmark"

class GraphqlController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.headers["Authorization"].present? }
  protect_from_forgery with: :exception, unless: -> { request.headers["Authorization"].present? }
  around_action :disable_gc, only: :execute, if: -> { Rails.env.development? }

  def graphiql; end

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = nil
    sql_events = []
    subscribe_to_sql_events(sql_events)
    execution_time = Benchmark.measure do
      result = GovukGraphqlSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    end

    schema_name = result.dig("data", "edition", "schema_name")
    locale = result.dig("data", "edition", "locale")
    set_prometheus_labels(schema_name:, locale:) if schema_name.present? || locale.present?

    render json: result.reverse_merge(execution_time_ms: format_benchmark(execution_time, sql_events))
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")

    render json: { errors: [{ message: error.message, backtrace: error.backtrace }], data: {} }, status: 500
  end

  def subscribe_to_sql_events(sql_events)
    ActiveSupport::Notifications.subscribe("sql.sequel") do |event|
      sql_events << {
        sql: event.payload[:sql]&.truncate(100),
        duration: event.duration,
      }
    end
  end

  def format_benchmark(execution_time, sql_events)
    execution_time.to_h
               .except(:label)
               .transform_values { (it * 1000).round(2) }
               .merge(sql_events: sql_events.map { it.merge(duration: it[:duration].round(2)) })
  end
end
