# frozen_string_literal: true

module API
  class PassengersController < ApplicationController
    def create
      if reservation_params
        status, json = CreateReservation.new.call(reservation_params)
        render json: json, status: status
      else
        render json: { status: :error, message: 'Invalid reservation' }, status: :bad_request
      end
    end

    private

    def reservation_params
      @reservation_params ||= {
        flight_execution_ref: params.require(:ref),
        user_token: params.require(:passenger).require(:user)
      }
    rescue StandardError
      nil
    end
  end
end
