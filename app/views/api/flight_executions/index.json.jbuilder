# frozen_string_literal: true

json.array! @flight_executions do |flight_execution|
  json.reference flight_execution.reference
  json.start_time flight_execution.start_time

  json.airplane do
    json.reference flight_execution.airplane.reference
    json.model flight_execution.airplane.model
  end

  json.flight do
    json.from_city flight_execution.flight.from_city
    json.to_city flight_execution.flight.to_city
  end
end
