class FoodsController < ApplicationController
  before_action :find_restaurant, only: [:index, :show]
  def index
    @foods = @restaurant.foods
    render json: @foods
  end

  def show
    @food = @restaurant.foods.find(params[:id])
    render json: @food
  end

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
