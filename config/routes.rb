Rails.application.routes.draw do
  resources :tests
  resources :answers
  resources :questions
  resources :categories
  resources :words
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
