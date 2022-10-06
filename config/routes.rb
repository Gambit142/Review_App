Rails.application.routes.draw do
  post "/signup", to: "users#create", format: 'json'
  post "/login", to: "sessions#create", format: 'json'
  get "/authorized", to: "sessions#show", format: 'json'
  root "root#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
