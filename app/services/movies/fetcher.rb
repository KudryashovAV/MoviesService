class Movies::Fetcher
  def self.call(movie_params)
    sql = <<-SQL
      movies.id as id,
      movies.movie_range as movie_range,
      movies.name as name,
      genres.id as genre_id,
      genres.name as genre_name,
      movie_rankings.rank_score as rank_score
    SQL

    scope = Movie.left_joins(:movie_rankings, genre: { preferred_genres: :user })
                 .select(sql)
                 .where(users: { id: [movie_params[:user_id], nil] })

    scope = scope.where("genres.name LIKE ?", "%#{movie_params[:query]}%") if movie_params[:query]
    scope = scope.where("movies.movie_range > ?", movie_params[:movie_range_min]) if movie_params[:movie_range_min]
    scope = scope.where("movies.movie_range < ?", movie_params[:movie_range_max]) if movie_params[:movie_range_max]

    scope.order("rank_score DESC NULLS LAST, movie_range ASC")
  end
end
