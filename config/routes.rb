Rails.application.routes.draw do

  devise_for :users

  resources :listings do
    member do
      post 'generate_lead'
    end
  end

  resources :conversations, :only => [:create,:show,:index, :destroy] do
    resources :messages, :only => [:create]
  end

  resources :charges

  resources :users, :only => [:edit, :update, :index, :show] do
    resources :conversations, :only => :index
    collection do
      post 'autocomplete'

      get 'autocomplete_market_search'
      get 'autocomplete_expertise_search'
      get 'autocomplete_dealmaker_search'
      get 'autocomplete_dealmaker_match_search'
    end
    member do
      post 'buy_tokens'
    end
  end

  root :to => 'listings#index'
  get 'pages/:page_name' => 'pages#index', :as => :pages
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  get '/:display_name' => 'users#show', :as => :profile
  post '/users/search' => 'users#search'
end
