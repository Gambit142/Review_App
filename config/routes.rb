Rails.application.routes.draw do
  # Route for Foods and Restaurants
  defaults format: :json do
    resources :restaurants, only: [:index, :show, :create] do
      resources :foods, only: [:index, :show]
    end
  end

  # Routes for authentication
  post "/signup", to: "users#create", format: 'json'
  post "/login", to: "sessions#create", format: 'json'
  get "/authenticated", to: "sessions#show", format: 'json'

  # Routes for Different Reviews
  get "/:type/:id/reviews", to: "reviews#show_reviews", format: 'json'
  get "/reviews-given", to: "reviews#user_reviews", format: 'json'
  post "/:type/:id/reviews", to: "reviews#create", format: 'json'

  root "root#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
