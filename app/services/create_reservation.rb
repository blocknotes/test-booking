# frozen_string_literal: true

class CreateReservation
  def call(flight_execution_ref:, user_token:)
    @flight_execution_ref = flight_execution_ref
    @user_token = user_token
    if user
      load_flight_execution
    else
      [:unauthorized, { status: :error, message: 'Invalid user' }]
    end
  end

  private

  def add_passenger
    flight_execution.passengers.build(user: user)
    if flight_execution.save
      [:ok, { status: :ok, message: 'Reservation complete' }]
    else
      log_errors(flight_execution.errors)
      [:unprocessable_entity, { status: :error, message: 'It was not possible to proceed with the reservation' }]
    end
  end

  def flight_execution
    @flight_execution ||=
      FlightExecution.where('start_time > ?', Time.current).find_by(reference: @flight_execution_ref)
  end

  def load_flight_execution
    if flight_execution&.confirm_availability?
      add_passenger
    else
      [:ok, { status: :warning, message: 'No availability for the selected flight' }]
    end
  end

  def log_errors(errors)
    error_message = "PassengersController#create: #{errors.full_messages.join(', ')}"
    Rails.logger.error(error_message)
  end

  def user
    @user ||= User.find_by(token: @user_token)
  end
end
