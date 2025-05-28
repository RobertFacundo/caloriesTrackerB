Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/signup', to: 'users#create'
      post '/login', to: 'auth#login'
      get '/me', to: 'users#me'
      patch 'users/update_details', to: 'users#update_details'

      resources :daily_logs do
        resources :meals do
          resources :ingredients
        end
      end
    end
  end
end 
