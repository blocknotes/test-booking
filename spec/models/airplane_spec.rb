# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airplane, type: :model do
  it { expect(described_class).to be < ApplicationRecord }

  describe 'associations' do
    it { is_expected.to have_many(:flight_executions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:reference) }
    it { is_expected.to validate_presence_of(:model) }
    it { is_expected.to validate_presence_of(:max_passengers) }
  end
end
