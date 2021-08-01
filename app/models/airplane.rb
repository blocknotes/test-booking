# frozen_string_literal: true

class Airplane < ApplicationRecord
  has_many :flight_executions, dependent: :destroy

  validates :reference, :model, :max_passengers, presence: true
end
