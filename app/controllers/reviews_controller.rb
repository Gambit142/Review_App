class ReviewsController < ApplicationController
  before_action :get_reviewable, only: [:create, :show_reviews]

  def show_reviews
    @reviews = @reviewable.reviews
    render json: @reviews
  end

  def user_reviews
    @user = current_user
    @reviews = @user.reviews
  end

  def create
    @review = @reviewable.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      render json: @review
    else
      render json: @review.errors.full_messages, status: 422
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
