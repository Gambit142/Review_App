class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
    render json: @restaurants
  end

  def show
    @restaurant = Restaurant.find(params[:id]).includes(:foods)
    render json: @restaurant
  end
end
