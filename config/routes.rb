Rails.application.routes.draw do
  namespace :api do
    namespace :admin do
      get 'words/index'
      get 'words/create'
      get 'words/edit'
      get 'words/update'
      get 'words/destroy'
    end
  end
  namespace :api do
    namespace :admin do
      get 'users/index'
      get 'users/create'
      get 'users/edit'
      get 'users/destroy'
      get 'users/update'
    end
  end
  root 'home#index'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'learn/:category_id', to: 'words#index', as: 'learn'
  post 'word/add_learnt_word', to: 'words#add_learnt_word'
  get 'learnt_words', to: 'words#learnt_words'

  namespace :admin do
    resources :answers
    resources :questions
    resources :categories
    resources :words
    resources :tests
    resources :users
  end
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

  resources :users, only: :show do
    member do
      get 'following', to: 'users#following'
      get 'followers', to: 'users#followers'
    end
  end

  resources :answers
  resources :questions
  resources :categories
  resources :words
  resources :relationships, only: [:create, :destroy]

  namespace :api, defaults: {format: :json} do
    devise_for :users
    as :user do
      #get 'login', to: 'users#new'
      post 'signup', to: 'registrations#create'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
    end
    scope '/categories' do
      get '', to: 'categories#index'
    end
    scope '/user' do
      get 'info', to: 'users#info'
      get ':user_id/newsfeed', to: 'users#newsfeed'
      get ':user_id/followers', to: 'users#followers'
      get ':user_id/following', to: 'users#following'
      patch 'update', to: 'users#update'
      post 'follow', to: 'users#follow'
      delete 'unfollow', to: 'users#unfollow'
    end
    scope '/test' do
      get ':id', to: 'tests#index'
      get ':id/result', to: 'tests#result'
      patch ':id', to: 'tests#update'
      post 'create', to: 'tests#create'
    end
    scope '/words' do 
      get '', to: 'words#index'
      post 'learntword', to: 'words#learntword'
      delete 'unlearntword', to: 'words#unlearntword'
    end
    namespace :admin do
      scope '/categories' do
        get '', to: 'categories#index'
        post '', to: 'categories#create'
        delete ':category_id', to: 'categories#destroy'
      end
      scope '/users' do
        get '', to: 'users#index'
        post '', to: 'users#create'
        delete ':user_id', to: 'users#destroy'
      end
      scope '/words' do
        get '', to: 'words#index'
        get 'options', to: 'words#options'
        post '', to: 'words#create'
        delete ':word_id', to: 'words#destroy'
      end
      scope '/questions' do
        get '', to: 'questions#index'
        post '', to: 'questions#create'
        delete ':question_id', to: 'questions#destroy'
      end
      scope '/answers' do
        get '', to: 'answers#index'
        post '', to: 'answers#create'
        delete ':answer_id', to: 'answers#destroy'
      end
    end
  end
end
