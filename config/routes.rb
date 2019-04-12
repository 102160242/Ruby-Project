Rails.application.routes.draw do
  root 'home#index'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'learn/:category_id', to: 'words#index', as: 'learn'
  post 'word/add_learnt_word', to: 'words#add_learnt_word'

  #get    '/login',   to: 'sessions#new'
  #post   '/login',   to: 'sessions#create'
  # delete '/logout',  to: 'sessions#destroy'
  #devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout'}
  ##get 'users/:id', to: 'users#show', as: 'usersssss'
  devise_for :users
  as :user do
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy', via: Devise.mappings[:user].sign_out_via
  end
  resources :tests, only: [:show, :create, :update] do
    member do
      get 'do', to: 'tests#edit'
    end
  end
  resources :users, only: :show
  resources :answers
  resources :questions
  resources :categories
  resources :words
end
