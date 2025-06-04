  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        post '/signup', to: 'users#create'
        post '/login', to: 'auth#login'
        get '/me', to: 'users#me'
        patch 'users/update_details', to: 'users#update_details'
        get '/stats/weekly', to: 'stats#weekly'
        get '/stats/monthly', to: 'stats#monthly'
        get '/stats/annually', to: 'stats#annually'
        patch 'daily_logs/update_training_day', to: 'daily_logs#update_training_day'

        resources :daily_logs do
          resources :meals do
            resources :ingredients, only: [:create, :update, :destroy]
          end
        end
        resources :weight_entries, only: [:index, :create]
      end
    end
  end 
