# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :flight_executions, only: %i[index], param: :ref do
      member do
        resources :passengers, only: %i[create]
      end
    end
  end
end
