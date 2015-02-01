Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  root :to => 'pages#home'
  get 'pages/:page_name' => 'pages#index', :as => :pages
end
