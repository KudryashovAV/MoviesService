require "rails_helper"

describe Movie do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:drama) { create :genre, name: "Drama" }

  let!(:drama_rsx) { create :movie, genre: drama, name: "RSX", movie_range: 57424, id: 179 }

  let!(:movie_ranking1) { create :movie_ranking, rank_score: 0.1205, movie: drama_rsx, user: user1 }
  let!(:movie_ranking2) { create :movie_ranking, rank_score: 0.1605, movie: drama_rsx, user: user2 }

  it "has relation to movie ranking" do
    expect(drama_rsx.movie_rankings.pluck(:id)).to match_array([movie_ranking1.id, movie_ranking2.id])
  end
end
