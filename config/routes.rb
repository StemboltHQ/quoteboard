Rails.application.routes.draw do
  devise_for :users
  root "quotes#index"
  resources :quotes do
    resources :votes, only: [:create, :update, :destroy]
  end
end
