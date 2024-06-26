Rails.application.routes.draw do
  devise_for :customers, path: 'customers'
  devise_for :users#, path: 'users'

  root to: "home#index"
  get 'select_login_type' => 'home#select_login_type'
  get 'select_sign_up_type' => 'home#select_sign_up_type'
 
  resources :venues, only: [:new, :create, :show, :edit, :update, :index] do
    get 'search', on: :collection
    post 'active', on: :member
    post 'inactive', on: :member
    resources :events, only: [:new, :create] do
      get 'deactivated', on: :collection
    end
  end
  
  resources :events, only: [:show] do
    resources :prices, only: [:new, :create]
    resources :orders, only: [:new, :create]
    post 'active', on: :member
    post 'inactive', on: :member
  end

  resources :orders, only: [:show, :index] do
    resources :quotations, only: [:new, :create]
    post 'approved', on: :member
    post 'confirmed', on: :member
    post 'canceled', on: :member
  end

  namespace :api do 
    namespace :v1 do 
      resources :venues, only: [:show, :index] do
        get 'search', on: :collection
        resources :events, only: [:index, :show] do
          get 'availability', on: :member
        end
      end
    end
  end

end
