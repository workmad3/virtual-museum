VirtualMuseum::Application.routes.draw do
  get "tags/show"
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :pages
  resources :tags

end