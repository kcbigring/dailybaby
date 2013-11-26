Admin::Application.routes.draw do
  devise_for :users
  root 'parents#index'
  resources :parents
  resources :kids
  resources :recipients
  resources :albums, only: [:index]
  resources :scheduled_emails, only: [:index]
  resources :sendgrid, only: [:index, :create]
end
