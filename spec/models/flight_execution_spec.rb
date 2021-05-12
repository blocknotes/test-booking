# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightExecution, type: :model do
  it { expect(described_class).to be < ApplicationRecord }

  describe 'associations' do
    it { is_expected.to belong_to(:airplane) }
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to have_many(:passengers) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_time) }
  end
end
