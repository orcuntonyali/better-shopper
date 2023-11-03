Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  post 'set_max_distance', to: 'users/registrations#set_max_distance'
  root "pages#home"
  get "/setup", to: "pages#setup", as: :setup

  # RESTful routes for resources
  resources :stores, only: [:index]
  resources :items
  resources :orders

  resources :cart_items, only: [:new, :show, :create, :update, :destroy] do
    collection do
      post 'process_audio'
      post 'process_order'
      get 'my_cart'
    end
    member do
      post'update_cart'
    end
  end
end
