class Movie < ApplicationRecord
  belongs_to :genre
  has_many :movie_rankings
end
