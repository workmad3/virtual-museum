VirtualMuseum::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations",
                                      :omniauth_callbacks => "omniauth_callbacks" }
  resources :users
  resources :pages
  resources :resources

  resources :tags,       only: [:show]
  resources :categories, only: [:show]
  resources :page_types, only: [:show]
  resources :moscow,     only: [:show]

  resources :pages do
    resources :comments
  end


end