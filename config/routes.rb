Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root "quotes#index"
  resources :quotes do
    resources :favourites, only: [:create]
    resources :votes, only: [:create, :update, :destroy]
  end
end
