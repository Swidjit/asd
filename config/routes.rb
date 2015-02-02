Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users do
    resource :blacklists
    resources :subscriptions, :only => [:create,:destroy,:index]
  end
  resources :meals do
    resources :rsvps
    resources :watches
    collection do
      get 'autocomplete_dietary_search'
      get 'custom'
    end

  end

  resources :comments, :only => [:create, :destroy]

  root :to => 'meals#index'
  get 'pages/:page_name' => 'pages#index', :as => :pages
  get '/:display_name' => 'users#show', :as => :profile
end
