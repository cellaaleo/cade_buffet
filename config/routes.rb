Rails.application.routes.draw do
  devise_for :customers, path: 'customers'
  devise_for :users#, path: 'users'

  root to: "home#index"
  get 'select_login_type' => 'home#select_login_type'
  get 'select_sign_up_type' => 'home#select_sign_up_type'
 
  resources :venues, only: [:new, :create, :show, :edit, :update, :index] do
    get 'search', on: :collection
    resources :events, only: [:new, :create]
  end
  
  resources :events, only: [:show] do
    resources :prices, only: [:new, :create]
  end
  
end
