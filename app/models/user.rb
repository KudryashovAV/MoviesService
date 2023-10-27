class User < ApplicationRecord
  has_many :preferred_genres, dependent: :destroy
  has_many :user_preferred_genre, through: :preferred_movies, source: :genre
  has_many :movie_rankings, dependent: :destroy
end
