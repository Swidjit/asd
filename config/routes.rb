Rails.application.routes.draw do

  devise_for :users

  resources :listings

  resources :conversations, :only => [:create,:show,:index, :destroy] do
    resources :messages, :only => [:create]
  end

  resources :users, :only => [:edit, :update, :index, :show] do
    resources :conversations, :only => :index
    collection do
      post 'autocomplete'
      get 'autocomplete_market_search'
    end
  end

  root :to => 'listings#index'
  get 'pages/:page_name' => 'pages#index', :as => :pages
  post '/users/search' => 'users#search'
end
