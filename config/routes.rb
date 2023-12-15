# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :shops do
        resources :schedules
      end
    end
  end
end
