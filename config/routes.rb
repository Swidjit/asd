Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users do
    resources :blacklists
    resources :whitelists
    resources :subscriptions, :only => [:create,:destroy,:index]
    resources :flags
    collection do
      post 'transfer_credits'
      post 'autocomplete'
    end
    member do
      get 'notifications'
      get 'credit_page'
      get 'manage_lists_page'
      post 'upload_file'
    end
  end
  resources :meals do
    resources :rsvps
    resources :watches
    resources :dishes
    collection do
      get 'autocomplete_dietary_search'
      get 'custom'
    end
    member do
      get 'show_rsvp'
    end
  end

  resources :conversations, :only => [:create,:show,:index, :destroy] do
    resources :messages, :only => [:create]
  end

  resources :users, :only => [:edit, :update] do
    resources :conversations, :only => :index
  end
  resources :comments, :only => [:create, :destroy, :update]

  root :to => 'meals#index'
  get 'pages/:page_name' => 'pages#index', :as => :pages
  get '/:display_name' => 'users#show', :as => :profile
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  post '/users/search' => 'users#search'
end
