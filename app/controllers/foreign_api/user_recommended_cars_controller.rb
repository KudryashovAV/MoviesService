class ForeignApi :: UserRecommendedMoviesController < ApplicationController

  def index
    render json: ForeignServices::UserRecommendedMoviesApi.call(records, user_movies_params[:user_id])
  end

  private

  def user_movies_params
    params.permit(:user_id)
  end
end
