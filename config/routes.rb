VirtualMuseum::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :pages
  resources :tags, only: [:index, :create, :show]
  resources :pages do
    resources :comments
  end

end