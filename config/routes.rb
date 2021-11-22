Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :batches, except: %i[destroy edit update] do
    resources :bookings, only: [:create]
    resources :costs, only: %i[create show update]
  end
  resources :users, only: [:show]
end
