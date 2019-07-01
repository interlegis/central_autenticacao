Rails.application.routes.draw do
  use_doorkeeper_openid_connect
  use_doorkeeper
  root 'sessions#new'
  resources :sessions, only: [:new, :create]
  get '/interlegis' => 'services_auth#interlegis_sign_in_page', :as => 'interlegis_page'
  post '/interlegis' => 'services_auth#interlegis_sign_in', :as => 'interlegis'
  get '/senado' => 'services_auth#cas_sign_in', :as => 'cas_senado'
  get '/login' => 'sessions#new', :as => :login
  get '/sessions' => 'sessions#new'
  delete 'logout' => 'sessions#destroy', :as => :logout
  resources :users, only: [:new, :create]
  get '/users' => 'users#show', :as => 'user'
  patch '/users' => 'users#update'
  put '/users' => 'users#update'
  post "oauth/callback" => "services_auth#callback"
  get "oauth/callback" => "services_auth#callback"
  get "oauth/:provider" => "services_auth#oauth", :as => :auth_at_provider
end
