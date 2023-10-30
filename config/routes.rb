Rails.application.routes.draw do
  get 'orders/show', to: 'orders#show' 
  get 'orders/create'
  get 'orders/delivery'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  post 'set_max_distance', to: 'users/registrations#set_max_distance'
  root "pages#home"
  get "/setup", to: "pages#setup", as: :setup 

  # RESTful routes for resources
  resources :stores, only: [:index]
  resources :items
  resources :orders, only: [:show]

  resources :cart_items, only: [:new, :show, :create, :update, :destroy] do
    collection do
      post 'process_audio'
      post 'process_order'
      get 'display_cart_items'
    end
  end
end