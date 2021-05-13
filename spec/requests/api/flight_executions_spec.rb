# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flight executions', type: :request do
  describe 'GET /index' do
    subject(:flight_executions) { get api_flight_executions_path(params) }

    context 'without parameters' do
      let(:params) { {} }

      before do
        flight_executions
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an invalid query error' do
        expected_params = { 'status' => 'error', 'message' => 'Invalid query' }

        expect(JSON.parse(response.body)).to match(expected_params)
      end
    end

    context 'with some missing parameters' do
      let(:params) { { q: { from: 'Milano', to: '', date: Date.tomorrow } } }

      before do
        flight_executions
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an invalid query error' do
        expected_params = { 'status' => 'error', 'message' => 'Invalid query' }

        expect(JSON.parse(response.body)).to match(expected_params)
      end
    end

    context 'with the required parameters' do
      let(:params) { { q: { from: from, to: to, date: Date.tomorrow } } }
      let(:from) { 'Milano' }
      let(:to) { 'Venezia' }
      let(:model) { '747' }
      let(:reference) { 'H321' }

      before do
        airplane = Airplane.create!(reference: reference, model: model, max_passengers: 5)
        flight = Flight.create!(from_city: from, to_city: to)
        FlightExecution.create!(start_time: Time.current.tomorrow, flight: flight, airplane: airplane)
        allow(FlightExecution).to receive(:includes).and_call_original
        flight_executions
      end

      it 'returns a status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'makes the query to check the flight executions' do
        expect(FlightExecution).to have_received(:includes).once
      end

      it 'returns the results as array' do
        expect(JSON.parse(body)).to be_a_kind_of Array
      end

      it 'returns the results with the airplane details' do
        first_result = JSON.parse(body).first

        expect(first_result).to match hash_including('airplane' => { 'model' => model, 'reference' => reference })
      end

      it 'returns the results with the flight details' do
        first_result = JSON.parse(body).first

        expect(first_result).to match hash_including('flight' => { 'from_city' => from, 'to_city' => to })
      end
    end
  end
end
