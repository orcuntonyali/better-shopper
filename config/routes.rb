Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  # RESTful routes for resources
  resources :stores
  resources :items
  resources :orders do
    resources :cart_items, only: [:create, :update, :destroy]
  end

end
