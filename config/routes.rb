Rails.application.routes.draw do
  devise_for :users, :path_prefix => 'my'
  root to: 'pages#home'

  resources :batches, only: :index  # for search box

  resources :batches, except: %i[destroy edit update] do
    resources :bookings, only: [:create, :destroy]
    resources :costs, only: %i[create show update destroy]
    resources :users, only: %i[index update destroy edit]
  end
end
