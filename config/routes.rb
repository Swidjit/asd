Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users
  resources :meals do
    resources :rsvps
    resources :watches
    collection do
      get 'autocomplete_dietary_search'
      get 'custom'
    end

  end

  root :to => 'pages#home'
  get 'pages/:page_name' => 'pages#index', :as => :pages
  get '/:display_name' => 'users#show', :as => :profile
end
