Rails.application.routes.draw do
  devise_for :users
  root "quotes#index"
  resources :quotes
  get '/quotes/error', to: 'quotes#error'
end
