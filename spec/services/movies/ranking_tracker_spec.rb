require "rails_helper"

describe Movies::RankingTracker do
  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let(:drama_genre) { create :genre, name: "Drama" }
  let(:comedy_genre) { create :genre, name: "Comedy" }
  let!(:drama_movie) { create :movie, genre: drama_genre, name: "RSX", movie_range: 57424, id: 179 }
  let!(:comedy_movie) { create :movie, genre: comedy_genre, name: "X5", movie_range: 57424, id: 200 }

  let!(:movie_ranking) { create :movie_ranking, rank_score: 0.1905, movie: drama_movie, user: user1 }

  let(:old_db_value) { [{ user_id: user1.id, rank_score: 0.1905 }] }
  let(:new_db_value) { [{ user_id: user1.id, rank_score: 0.945 },
                        { user_id: user1.id, rank_score: 0.645 },
                        { user_id: user2.id, rank_score: 0.945 },
                        { user_id: user2.id, rank_score: 0.645 }] }

  before do
    recommended_movies = [
      { "movie_id": 179, "rank_score": 0.945 },
      { "movie_id": 200, "rank_score": 0.645 }
    ]
    stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_movies.json").
      to_return(status: 200, body: recommended_movies.to_json)
  end

  it "creates records" do
    expect { described_class.call }.to change(MovieRanking, :count).from(1).to(4)
  end

  it "rewrites records" do
    expect(MovieRanking.all.map { |cr| { user_id: cr.user.id, rank_score: cr.rank_score.to_f } })
      .to match_array(old_db_value)

    described_class.call

    expect(MovieRanking.all.map { |cr| { user_id: cr.user.id, rank_score: cr.rank_score.to_f } })
      .to match_array(new_db_value)
  end
end
