Rails.application.routes.draw do
  resources :reviews

  # Route for Foods and Restaurants
  defaults format: :json do
    resources :Restaurants, only: [:index, :show] do
      resources :foods, only: [:index, :show]
    end
  end

  # Routes for authentication
  post "/signup", to: "users#create", format: 'json'
  post "/login", to: "sessions#create", format: 'json'
  get "/authenticated", to: "sessions#show", format: 'json'

  # Routes for Different Reviews
  get "/foods/:id/reviews", to: "reviews#food_reviews", format: 'json'
  get "/restaurants/:id/reviews", to: "reviews#restaurant_reviews", format: 'json'
  get "/users/:id/reviews", to: "reviews#user_reviews", format: 'json'

  root "root#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
