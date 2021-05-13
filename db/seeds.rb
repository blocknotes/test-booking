# frozen_string_literal: true

puts '> Airplanes...'
airplanes = [
  { reference: 'G725', model: '747' },
  { reference: 'H813', model: '727' },
  { reference: 'J232', model: '747' }
]
airplanes.each_with_index do |airplane, index|
  airplane[:max_passengers] = 100 + index * 10
  Airplane.find_or_create_by!(airplane)
end

puts '> Flights...'
flights = [
  { from_city: 'Milano', to_city: 'Venezia', duration: 60 },
  { from_city: 'Roma', to_city: 'Napoli' },
  { from_city: 'Roma', to_city: 'Venezia' }
]
flights.each do |flight|
  Flight.find_or_create_by!(flight)
end

puts '> Flight executions...'
flight_executions = [
  { flight: Flight.first, airplane: Airplane.first, reference: 'MIVE11', start_time: Time.current + 30.days },
  { flight: Flight.third, airplane: Airplane.third, reference: 'ROVE25', start_time: Time.current + 28.days },
  { flight: Flight.first, airplane: Airplane.second, reference: 'MIVE04', start_time: Time.current + 32.days }
]
flight_executions.each do |flight_execution|
  FlightExecution.find_or_create_by!(flight_execution)
end

puts '> Users...'
users = [
  { name: 'Mario Rossi', email: 'mario.rossi@example.com', token: 'some_jwt_token_1' },
  { name: 'Luigi Verdi', email: 'luigi.verdi@example.com', token: 'some_jwt_token_2' },
  { name: 'Anna Bianchi', email: 'anna.bianchi@example.com', token: 'some_jwt_token_3' }
]
users.each do |user|
  User.find_or_create_by!(user)
end

puts '> Passengers...'
passengers = [
  { flight_execution: FlightExecution.first, user: User.first },
  { flight_execution: FlightExecution.first, user: User.last },
  { flight_execution: FlightExecution.second, user: User.second }
]
passengers.each do |passenger|
  Passenger.find_or_create_by!(passenger)
end

puts 'done.'
