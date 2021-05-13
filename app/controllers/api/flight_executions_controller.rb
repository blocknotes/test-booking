# frozen_string_literal: true

module API
  class FlightExecutionsController < ApplicationController
    MAX_RESULTS = 100

    def index
      if query_params.present?
        @flight_executions = look_for_flight_executions(
          from: query_params[:from],
          to: query_params[:to],
          date: query_params[:date]
        )
      else
        render json: { status: :error, message: 'Invalid query' }, status: :bad_request
      end
    end

    private

    def query_params
      @query_params ||=
        params.require(:q).permit(:from, :to, :date).tap do |q|
          q.require(%i[from to date])
        end
    rescue StandardError # ignore parameters errors
      nil
    end

    def look_for_flight_executions(from:, to:, date:)
      FlightExecution
        .includes(:airplane, :flight)
        .by_path(from, to)
        .by_date(date)
        .with_availability
        .order(start_time: :asc)
        .limit(MAX_RESULTS)
    end
  end
end
