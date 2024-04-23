Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  resources :venues, only: [:new, :create, :show, :edit, :update, :index] do
    get 'search', on: :collection
  end
  resources :events, only: [:new, :create, :show, :index]
  resources :prices, only: [:new, :create]
end
