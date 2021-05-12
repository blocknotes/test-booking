# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passenger, type: :model do
  it { expect(described_class).to be < ApplicationRecord }

  describe 'associations' do
    it { is_expected.to belong_to(:flight_execution) }
    it { is_expected.to belong_to(:user) }
  end
end
