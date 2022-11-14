class RestaurantsController < ApplicationController
  def index
    if logged_in?
      @restaurants = Restaurant.all
      render json: @restaurants
    else
      render json: {error: "You must be logged in to view this page"}
    end
  end

  def show
    if logged_in?
      @restaurant = Restaurant.find(params[:id]).includes(:foods)
      render json: @restaurant
    else
      render json: {error: "You must be logged in to view this page"}
    end
  end

  def create
    if logged_in?
      @restaurant = Restaurant.new(restaurant_params)
      if @restaurant.save
        render json: @restaurant
      else
        render json: @restaurant.errors.full_messages, status: 422
      end
    else
      render json: {error: "You must be logged in to view this page"}
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :country_code, 
                  :country, :continent, :address, :email, :website, :image)
  end
end
