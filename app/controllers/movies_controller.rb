class MoviesController < ApplicationController
  include Pagy::Backend

  def index
    if movie_params[:user_id].blank?
      render json: { error: "'user_id' parameter is required" }, status: :bad_request
      return
    end

    Movies::RankingFetcher.call(movie_params[:user_id])

    _, records = pagy(Movies::Fetcher.call(movie_params.to_h), page: movie_params[:page])

    render json: Movies::ResponseBuilder.call(records, movie_params[:user_id])
  end

  private

  def movie_params
    params.permit(:user_id, :query, :movie_range_min, :movie_range_max, :page)
  end
end
