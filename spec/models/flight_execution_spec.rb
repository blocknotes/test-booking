# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightExecution, type: :model do
  let(:airplane) { Airplane.create!(reference: 'H321', model: '747') }
  let(:flight) { Flight.create!(from_city: 'Milano', to_city: 'Venezia') }

  it { expect(described_class).to be < ApplicationRecord }

  describe 'associations' do
    it { is_expected.to belong_to(:airplane) }
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to have_many(:passengers) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_time) }
  end

  describe 'scope by_date' do
    subject(:by_date) { described_class.by_date(date).map(&:to_s) }

    let(:date) { Time.zone.tomorrow }

    before do
      # Create some data
      described_class.create!(airplane: airplane, flight: flight, start_time: Time.current.yesterday)
      described_class.create!(airplane: airplane, flight: flight, start_time: Time.current + 1.hour)
      described_class.create!(airplane: airplane, flight: flight, start_time: Time.current + 2.days)
    end

    it { is_expected.to be_empty }

    context 'with 2 flight executions for tomorrow' do
      let!(:flight_execution) do
        described_class.create!(airplane: airplane, flight: flight, start_time: Time.current.tomorrow.end_of_day)
      end
      let!(:flight_execution2) do
        described_class.create!(airplane: airplane, flight: flight, start_time: Time.current.tomorrow.beginning_of_day)
      end

      it { is_expected.to match_array [flight_execution.to_s, flight_execution2.to_s] }
    end
  end

  describe 'scope by_path' do
    subject(:by_path) { described_class.joins(:flight).by_path(from, to).map(&:to_s) }

    let(:flight2) { Flight.create!(from_city: 'Venezia', to_city: 'Napoli') }
    let(:flight3) { Flight.create!(from_city: from, to_city: to) }
    let(:from) { 'Milano' }
    let(:to) { 'Roma' }

    before do
      # Create some data
      described_class.create!(airplane: airplane, flight: flight, start_time: Time.current)
      described_class.create!(airplane: airplane, flight: flight2, start_time: Time.current.tomorrow)
    end

    it { is_expected.to be_empty }

    context 'with a flight execution for the required path' do
      let!(:flight_execution) do
        described_class.create!(airplane: airplane, flight: flight3, start_time: Time.current.yesterday)
      end

      it { is_expected.to match_array [flight_execution.to_s] }
    end
  end

  describe 'scope with_availability' do
    subject(:with_availability) { described_class.joins(:airplane).with_availability.map(&:to_s) }

    before do
      described_class.create!(airplane: airplane, flight: flight, start_time: Time.current)
    end

    it { is_expected.to be_empty }

    context 'with an airplane with some availability' do
      let(:airplane2) { Airplane.create!(reference: 'H321', model: '747', max_passengers: 5) }
      let!(:flight_execution) do
        described_class.create!(airplane: airplane2, flight: flight, start_time: Time.current)
      end

      it { is_expected.to match_array [flight_execution.to_s] }
    end
  end

  describe '#to_s' do
    subject(:to_s) { flight_execution.to_s }

    let(:flight_execution) { described_class.new(start_time: Time.current, flight: flight) }
    let(:flight) { Flight.new(from_city: 'Venezia', to_city: 'Milano') }

    it { is_expected.to match(/Venezia-Milano/) }
  end
end
