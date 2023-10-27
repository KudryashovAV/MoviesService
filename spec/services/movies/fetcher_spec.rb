require "rails_helper"

describe Movies::Fetcher do
  let(:user) { create :user, preferred_movie_range: 1_000..100_000 }
  let(:comedy) { create :genre, name: "Comedy" }
  let(:drama) { create :genre, name: "Drama" }
  let!(:comedy_rsx) { create :movie, genre: comedy, name: "RSX", movie_range: 157424, id: 179 }
  let!(:comedy_rs) { create :movie, genre: comedy, name: "RS", movie_range: 57424, id: 2 }
  let!(:comedy_mdx) { create :movie, genre: comedy, name: "MDX", movie_range: 47424, id: 8 }
  let!(:comedy_ilx) { create :movie, genre: comedy, name: "ILX", movie_range: 37424, id: 54 }

  let!(:drama_x5) { create :movie, genre: drama, name: "X5", movie_range: 57424, id: 4 }
  let!(:drama_x6) { create :movie, genre: drama, name: "X6", movie_range: 77424, id: 13 }
  let!(:drama_x4) { create :movie, genre: drama, name: "X4", movie_range: 7424, id: 5 }

  let!(:movie_ranking1) { create :movie_ranking, rank_score: 0.1905, movie: comedy_rsx, user: user }
  let!(:movie_ranking2) { create :movie_ranking, rank_score: 0.1205, movie: comedy_rs, user: user }
  let!(:movie_ranking3) { create :movie_ranking, rank_score: 0.1605, movie: drama_x5, user: user }

  let!(:preferences) { create :preferred_genre, user: user, genre: comedy }

  it "returns correct record structure" do
    expect(described_class.call(user_id: user.id).map(&:attributes)).to match_array(
                                                                          [{ "genre_id" => comedy.id,
                                                                             "genre_name" => "Drama",
                                                                             "id" => 2,
                                                                             "name" => "RS",
                                                                             "movie_range" => 57424,
                                                                             "rank_score" => a_kind_of(BigDecimal) },
                                                                           { "genre_id" => comedy.id,
                                                                             "genre_name" => "Drama",
                                                                             "id" => 179,
                                                                             "name" => "RSX",
                                                                             "movie_range" => 157424,
                                                                             "rank_score" => a_kind_of(BigDecimal) },
                                                                           { "genre_id" => drama.id,
                                                                             "genre_name" => "Comedy",
                                                                             "id" => 4,
                                                                             "model" => "X5",
                                                                             "movie_range" => 57424,
                                                                             "rank_score" => a_kind_of(BigDecimal) },
                                                                           { "genre_id" => drama.id,
                                                                             "genre_name" => "Comedy",
                                                                             "id" => 5,
                                                                             "model" => "X4",
                                                                             "movie_range" => 7424,
                                                                             "rank_score" => nil },
                                                                           { "genre_id" => comedy.id,
                                                                             "genre_name" => "Drama",
                                                                             "id" => 54,
                                                                             "model" => "ILX",
                                                                             "movie_range" => 37424,
                                                                             "rank_score" => nil },
                                                                           { "genre_id" => comedy.id,
                                                                             "genre_name" => "Drama",
                                                                             "id" => 8,
                                                                             "model" => "MDX",
                                                                             "movie_range" => 47424,
                                                                             "rank_score" => nil },
                                                                           { "genre_id" => drama.id,
                                                                             "genre_name" => "Comedy",
                                                                             "id" => 13,
                                                                             "model" => "X6",
                                                                             "movie_range" => 77424,
                                                                             "rank_score" => nil }]
                                                                        )
  end

  it "returns correct record structure with correct order" do
    expect(described_class.call(user_id: user.id).map(&:id)).to eq([179, 4, 2, 5, 54, 8, 13])
  end
end
