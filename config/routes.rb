Rails.application.routes.draw do
  root "quotes#index"
  resources :quotes
  get '/quotes/error', to: 'quotes#error'
end
