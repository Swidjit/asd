Rails.application.routes.draw do

  devise_for :users

  resources :listings do
    resources :images, :only => [:destroy]
    member do
      post 'generate_lead'
      post 'upload_file'
    end
    collection do
      get 'filter'
    end
  end

  resources :conversations, :only => [:create,:show,:index, :destroy] do
    resources :messages, :only => [:create]
  end

  resources :charges

  resources :users, :only => [:edit, :update, :index, :show] do
    resources :conversations, :only => :index
    resources :leads, :only => :index
    collection do
      post 'autocomplete'
      get 'filter'
      get 'autocomplete_market_search'
      get 'autocomplete_expertise_search'
      get 'autocomplete_dealmaker_search'
      get 'autocomplete_dealmaker_match_search'
      get 'confirm'
    end
    member do
      post 'buy_tokens'
      post 'upload_file'
      get 'listings'
      get 'edit_password'

    end
  end
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end

  root :to => 'pages#home'
  get 'landing', :to => 'pages#landing'
  get 'defaultsite', :to => 'pages#landing'
  get 'pages/:page_name' => 'pages#index', :as => :pages
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  get '/:display_name' => 'users#show', :as => :profile
  post '/users/search' => 'users#search'
end
