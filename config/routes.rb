Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  resources :venues, only: [:new, :create, :show, :edit, :update, :index]
  resources :events, only: [:new, :create, :show, :index]
  resources :prices, only: [:new, :create]
end
