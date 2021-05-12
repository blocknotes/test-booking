# frozen_string_literal: true

class FlightExecution < ApplicationRecord
  belongs_to :airplane
  belongs_to :flight
  has_many :passengers, dependent: :destroy

  validates :start_time, presence: true
end
