VirtualMuseum::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations",
                                      :omniauth_callbacks => "omniauth_callbacks" }
  resources :users
  resources :pages
  resources :resources

  resources :tags, only: [:index, :create, :show]
  resources :categories, only: [:index, :create, :show]
  resources :page_types, only: [:index, :create, :show]

  resources :pages do
    resources :comments
  end


end