class Genre < ApplicationRecord
  has_many :preferred_genre, dependent: :destroy
  has_many :genre_preferred_users, through: :preferred_genre, source: :user
  has_many :movies, dependent: :destroy
end
