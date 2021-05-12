# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(described_class).to be < ApplicationRecord }

  describe 'associations' do
    it { is_expected.to have_many(:passengers) }
  end

  describe 'validations' do
    before do
      described_class.create!(name: 'A name', email: 'An email', token: 'A token')
    end

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_uniqueness_of(:token) }
  end
end
