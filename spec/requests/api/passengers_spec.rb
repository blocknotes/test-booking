# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passengers', type: :request do
  shared_context 'when creating passenger' do
    let(:flight_executions) { instance_double(ActiveRecord::Relation, find_by: flight_execution) }
    let(:params) { { ref: 'REF', passenger: { user: 'some_jwt_token_1' } } }
    let(:passengers) { instance_double(ActiveRecord::Relation, build: true) }
    let(:user) { instance_double(User) }

    before do
      allow(FlightExecution).to receive(:where).and_return(flight_executions)
      allow(User).to receive(:find_by).and_return(user)
      create_passenger
    end
  end

  describe 'POST /create' do
    subject(:create_passenger) { post api_passengers_path(params) }

    context 'without a flight execution' do
      let(:params) { {} }

      it 'raises an exception' do
        expect { create_passenger }.to raise_exception(ActionController::UrlGenerationError, /missing required keys/)
      end
    end

    context 'without a user token' do
      let(:params) { { ref: 'REF' } }

      before do
        create_passenger
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an invalid reservation error' do
        expected_params = { 'status' => 'error', 'message' => 'Invalid reservation' }

        expect(JSON.parse(response.body)).to match(expected_params)
      end
    end

    context 'without the flight execution' do
      let(:flight_execution) { nil }

      include_context 'when creating passenger'

      it 'returns a status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a warning about no availability' do
        expected_params = { 'status' => 'warning', 'message' => 'No availability for the selected flight' }

        expect(JSON.parse(response.body)).to match(expected_params)
      end
    end

    context 'with an invalid user token' do
      let(:params) { { ref: 'REF', passenger: { user: 'invalid_token' } } }

      before do
        create_passenger
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an invalid user error' do
        expected_params = { 'status' => 'error', 'message' => 'Invalid user' }

        expect(JSON.parse(response.body)).to match(expected_params)
      end
    end

    context "when there's an error while saving the flight execution" do
      let(:errors) { instance_double(ActiveModel::Errors, full_messages: ['Some errors']) }
      let(:flight_execution) do
        instance_double(FlightExecution, confirm_availability?: true).tap do |fe|
          allow(fe).to receive_messages(passengers: passengers, save: false, errors: errors)
        end
      end

      before do
        allow(Rails.logger).to receive(:error)
      end

      include_context 'when creating passenger'

      it 'returns a status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a warning about no availability' do
        expected_params = { 'status' => 'error', 'message' => 'It was not possible to proceed with the reservation' }

        expect(JSON.parse(response.body)).to match(expected_params)
      end

      it 'logs an error' do
        expect(Rails.logger).to have_received(:error).with(/Some errors/)
      end
    end

    context 'when the flight execution is available' do
      let(:flight_execution) do
        instance_double(FlightExecution, confirm_availability?: true).tap do |fe|
          allow(fe).to receive_messages(passengers: passengers, save: true)
        end
      end

      include_context 'when creating passenger'

      it 'returns a status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an operation completed message' do
        expected_params = { 'status' => 'ok', 'message' => 'Reservation complete' }

        expect(JSON.parse(response.body)).to match(expected_params)
      end
    end
  end
end
