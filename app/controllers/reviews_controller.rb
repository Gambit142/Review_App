class ReviewsController < ApplicationController
  before_action :get_reviewable, only: [:create, :show_reviews]

  def show_reviews
    if logged_in?
      @reviews = @reviewable.reviews
      render json: @reviews
    else
      render json: {error: "You must be logged in to view this page"}
    end
  end

  def user_reviews
    if logged_in?
      @user = current_user
      @reviews = @user.reviews
    else
      render json: {error: "You must be logged in to view this page"}
    end
  end

  def create
    if logged_in?
      @review = @reviewable.reviews.new(review_params)
      @review.user = current_user
      if @review.save
        render json: @review
      else
        render json: @review.errors.full_messages, status: 422
      end
    else
      render json: {error: "You must be logged in to view this page"}
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def get_reviewable
    type = params[:type].singularize.capitalize.constantize
    @reviewable = type.find(params[:id])
  end
end
