Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  resources :meals

  root :to => 'pages#home'
  get 'pages/:page_name' => 'pages#index', :as => :pages
  get '/:display_name' => 'users#show', :as => :profile
end
