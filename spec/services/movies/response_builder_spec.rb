require "rails_helper"

describe Movies::ResponseBuilder do
  let(:user) { create :user, preferred_movie_range: 1_000..100_000 }

  let(:drama) { create :genre, name: "Drama", id: 3 }
  let(:comedy) { create :genre, name: "Comedy", id: 5  }

  let!(:drama_rsx) { create :movie, genre: drama, name: "RSX", movie_range: 57424, id: 179 }
  let!(:drama_mdx) { create :movie, genre: drama, name: "MDX", movie_range: 147424, id: 8 }
  let!(:drama_ilx) { create :movie, genre: drama, name: "ILX", movie_range: 137424, id: 54 }

  let!(:comedy_x6) { create :movie, genre: comedy, name: "X6", movie_range: 58424, id: 13 }
  let!(:comedy_x5) { create :movie, genre: comedy, name: "X5", movie_range: 147424, id: 45 }
  let!(:comedy_x4) { create :movie, genre: comedy, name: "X4", movie_range: 137424, id: 5 }

  let!(:preferences) { create :preferred_genre, user: user, genre: drama }

  let(:raw_movies) {[
    OpenStruct.new(id: 179, genre_id: 3, genre_name: "Drama", name: "RSX", movie_range: 57424, rank_score: 0.945),
    OpenStruct.new(id: 8, genre_id: 3, genre_name: "Drama", name: "MDX", movie_range: 147424, rank_score: 0.935),
    OpenStruct.new(id: 54, genre_id: 3, genre_name: "Drama", name: "ILX", movie_range: 137424, rank_score: 0.925),
    OpenStruct.new(id: 45, genre_id: 5, genre_name: "Comedy", name: "X5", movie_range: 58424, rank_score: 0.235),
    OpenStruct.new(id: 5, genre_id: 5, genre_name: "Comedy", name: "X4", movie_range: 137424, rank_score: nil),
    OpenStruct.new(id: 13, genre_id: 5, genre_name: "Comedy", name: "X6", movie_range: 147424, rank_score: nil)
  ]}

  it "returns correct record structure and order" do
    expect(described_class.call(raw_movies, user.id)).to eq([
      { id: 179, genre: { id: 3, name: "Drama" }, movie_range: 57424, rank_score: 0.945, name: "RSX", label: "perfect_match" },
      { id: 8, genre: { id: 3, name: "Drama" }, movie_range: 147424, rank_score: 0.935, name: "MDX", label: "good_match" },
      { id: 54, genre: { id: 3, name: "Drama" }, movie_range: 137424, rank_score: 0.925, name: "ILX", label: "good_match" },
      { id: 45, genre: { id: 5, name: "Comedy" }, movie_range: 58424, rank_score: 0.235, name: "X5", label: nil },
      { id: 5, genre: { id: 5, name: "Comedy" }, movie_range: 137424, rank_score: nil, name: "X4", label: nil },
      { id: 13, genre: { id: 5, name: "Comedy" }, movie_range: 147424, rank_score: nil, model: "X6", label: nil }])
  end
end
