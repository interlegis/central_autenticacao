Rails.application.routes.draw do
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
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
  get '/panel' => 'users#panel', as: 'panel_keys'
  put '/users' => 'users#update'
  get '/users/edit' => 'users#edit', :as => 'edit_user'
  get '/users/password' => 'users#edit_pw', :as => 'edit_password'
  post "oauth/callback" => "services_auth#callback"
  get "oauth/callback" => "services_auth#callback"
  get "oauth/:provider" => "services_auth#oauth", :as => :auth_at_provider
  get 'api/level' => 'api_accesses#verify_api_level', :as => :api_level_verification
  resources :api_accesses, path: 'api', only: [:new, :create, :update]
  post 'api/create_remote' => 'api_accesses#create_remote'
  resources :password_resets, only: [:create, :edit, :update]
end
