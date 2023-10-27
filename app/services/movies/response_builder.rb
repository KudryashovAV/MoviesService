class Movies::ResponseBuilder
  def self.call(movies, user_id)
    new(movies, user_id).call
  end

  def initialize(movies, user_id)
    @movies = movies
    @user_id = user_id
    @perfect_movies = []
    @good_movies = []
    @regular_movies = []
  end

  def call
    sort_movies

    build_data(@perfect_movies, "perfect_match") + build_data(@good_movies, "good_match") + build_data(@regular_movies)
  end

  private

  def sort_movies
    movie_data = fetch_movie_data

    @movies.each do |movie|
      if movie_data[movie.id].blank?
        @regular_movies << movie
      elsif movie_data[movie.id].find { |data| data["movie_range"].include?(movie.movie_range)}.blank?
        @good_movies << movie
      else
        @perfect_movies << movie
      end
    end
  end

  def fetch_movie_data
    User.left_joins(preferred_genres: { genre: :movies })
        .select("users.preferred_movie_range as movie_range, movies.id as movie_id")
        .where(users: { id: @user_id }, movies: { id: @movies.map(&:id) })
        .group_by(&:movie_id)
  end

  def build_data(movies, label = nil)
    movies.map do |movie|
      {
        id: movie.id,
        genre: {
          id: movie.genre_id,
          name: movie.genre_name
        },
        movie_range: movie.movie_range,
        rank_score: movie.rank_score&.to_f,
        name: movie.name,
        label: label
      }
    end
  end
end
