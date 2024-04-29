Rails.application.routes.draw do
  devise_for :customers, path: 'customers'#, controllers: { sessions: "customers/sessions", registrations: "customers/registrations" }
  devise_for :users, path: 'users'

  root to: "home#index"
  resources :venues, only: [:new, :create, :show, :edit, :update, :index] do
    get 'search', on: :collection
  end
  resources :events, only: [:new, :create, :show]#, :index]
  resources :prices, only: [:new, :create]
end
