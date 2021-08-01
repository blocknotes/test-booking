# frozen_string_literal: true

class Passenger < ApplicationRecord
  belongs_to :flight_execution, counter_cache: true
  belongs_to :user
end
