Rails.application.routes.draw do
  resources :reviews

  # Route for Foods and Restaurants
  defaults format: :json do
    resources :Restaurants, only: [:index, :show] do
      resources :foods, only: [:index, :show]
    end
  end

  post "/signup", to: "users#create", format: 'json'
  post "/login", to: "sessions#create", format: 'json'
  get "/authorized", to: "sessions#show", format: 'json'
  root "root#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
