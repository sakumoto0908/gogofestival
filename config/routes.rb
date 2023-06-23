Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
  get 'profiles/show'
  get 'profiles/edit'
  get 'sessions/new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root 'pages#index'
  root 'festivals#index'
  
  resources :users
  resources :topics do
    resources :comments
  end
  resources :festivals

  get '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  get 'favorites/index'
  post '/favorites', to: 'favorites#create'
  delete '/favorites', to: 'favorites#destroy'
  
  get 'gones/index'
  post '/gones', to: 'gones#create'
  delete '/gones', to: 'gones#destroy'
  
  get 'wantgos/index'
  post '/wantgos', to: 'wantgos#create'
  delete '/wantgos', to: 'wantgos#destroy'
  
  get 'festivals/index', to: 'festivals#path'
  get 'festivals/:id', to: 'festivals#show'
  
  resource :profile, only: %i[show edit update]
end
