Rails.application.routes.draw do
  devise_for :users, :path_prefix => 'my'
  root to: 'pages#home'

  resources :batches, except: %i[destroy edit update] do
    resources :costs, only: %i[create show update destroy]
    resources :users, only: %i[index update destroy edit]
  end
  resources :bookings, only: [:create] do
    member do
      patch :accept
      patch :pending
    end
  end

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  get '/422', to: 'errors#unprocessable'
end
