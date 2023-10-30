Rails.application.routes.draw do
  get 'orders/show'
  devise_for :users
  root "pages#home"

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

