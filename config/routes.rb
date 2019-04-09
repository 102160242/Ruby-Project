Rails.application.routes.draw do
  root 'home#index'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  #get    '/login',   to: 'sessions#new'
  #post   '/login',   to: 'sessions#create'
  # delete '/logout',  to: 'sessions#destroy'
  #devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout'}
  devise_for :users
  as :user do
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy', via: Devise.mappings[:user].sign_out_via
  end
  resources :tests
  resources :answers
  resources :questions
  resources :categories
  resources :words
  #resources :users
end
