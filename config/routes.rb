Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root "quotes#index"
  get "/favourite_quotes", to: "favourites#favourite_quotes"
  resources :quotes do
    resources :favourites, only: [:create, :destroy]
    resources :votes, only: [:create, :update, :destroy]
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :quotes, only: [:create]
      resources :people, only: [:create]
    end
  end
end
