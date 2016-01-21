Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root "quotes#index"
  resources :quotes do
    get :best, on: :collection
    resources :votes, only: [:create, :update, :destroy]
  end
end
