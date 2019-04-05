Rails.application.routes.draw do
  root 'home#index'
  resources :tests
  resources :answers
  resources :questions
  resources :categories
  resources :words
  resources :users

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'
end
