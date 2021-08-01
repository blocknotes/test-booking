# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flight, type: :model do
  it { expect(described_class).to be < ApplicationRecord }

  describe 'associations' do
    it { is_expected.to have_many(:flight_executions) }
  end

  describe 'validations' do
    let(:message) { 'should be unique in conjunction with the destination city' }

    before do
      described_class.create!(from_city: 'Milano', to_city: 'Venezia')
    end

    it { is_expected.to validate_presence_of(:from_city) }
    it { is_expected.to validate_presence_of(:to_city) }

    it { is_expected.to validate_uniqueness_of(:from_city).scoped_to(:to_city).case_insensitive.with_message(message) }
  end
end
