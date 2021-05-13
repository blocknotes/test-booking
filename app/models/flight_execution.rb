# frozen_string_literal: true

class FlightExecution < ApplicationRecord
  belongs_to :airplane
  belongs_to :flight
  has_many :passengers, dependent: :destroy

  validates :start_time, presence: true

  scope :by_date, ->(date) { where('start_time > ?', Time.current).where('DATE(start_time) = ?', date) }
  scope :by_path, ->(from, to) { where(flight: { from_city: from, to_city: to }) } # requires flight join
  scope :with_availability, -> { where('passengers_count < airplanes.max_passengers') } # requires airplane join

  def to_s
    "#{flight.from_city}-#{flight.to_city} @ #{start_time}"
  end
end
