Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  # RESTful routes for resources
  resources :stores, only: [:index]
  resources :items
  resources :orders

  resources :cart_items, only: [:new, :show, :create, :update, :destroy] do
    collection do
      post 'process_audio'
      post 'process_order'
    end
  end
end
