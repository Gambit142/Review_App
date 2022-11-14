class FoodsController < ApplicationController
  before_action :find_restaurant, only: [:index, :show]
  def index
    if logged_in?
      @foods = @restaurant.foods
      render json: @foods
    else
      render json: {error: "You must be logged in to view this page"}
    end
  end

  def show
    if logged_in?
      @food = @restaurant.foods.find(params[:id])
      render json: @food
      else
        render json: {error: "You must be logged in to view this page"}
    end
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
