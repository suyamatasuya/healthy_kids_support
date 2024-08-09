Rails.application.routes.draw do
  
  resources :users, only: [:create]

  devise_for :users, skip: [:registrations], controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get '/csrf_token', to: 'application#csrf_token'

  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end
