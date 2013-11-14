Admin::Application.routes.draw do
  devise_for :users
  root 'parents#index'
  resources :parents
  resources :kids
  resources :recipients
  resources :albums
  resources :sendgrid, only: [:index, :create]
end
