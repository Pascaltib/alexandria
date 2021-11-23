Rails.application.routes.draw do
  devise_for :users, :path_prefix => 'my'

  root to: 'pages#home'
  resources :batches, except: %i[destroy edit update] do
    resources :bookings, only: [:create]
    resources :costs, only: %i[create show update]
    resources :users, only: [:index, :update, :destroy, :edit]
  end

end
