# frozen_string_literal: true

class Flight < ApplicationRecord
  has_many :flight_executions, dependent: :destroy

  validates :from_city, :to_city, presence: true
  validates :from_city, uniqueness: {
    scope: :to_city,
    case_sensitive: false,
    message: 'should be unique in conjunction with the destination city'
  }
end
