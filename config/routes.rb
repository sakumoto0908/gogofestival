Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'profiles/show'
  get 'profiles/edit'
  get 'sessions/new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
  
  resources :users
  resources :topics

  get '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  get 'favorites/index'
  post '/favorites', to: 'favorites#create'
  delete '/favorites', to: 'favorites#destroy'
  
  resource :profile, only: %i[show edit update]
end
