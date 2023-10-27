require "rails_helper"

describe Movies::RankingFetcher do
  context "when movie rank exist for user" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }
    let(:drama) { create :genre, name: "Drama" }
    let!(:drama_rsx) { create :movie, genre: drama, name: "RSX", movie_range: 57424, id: 179 }
    let!(:movie_ranking) { create :movie_ranking, rank_score: 0.1905, movie: drama_rsx, user: user }

    it "returns records" do
      expect(described_class.call(user.id).size).to eq(1)
    end

    it "returns correct record structure" do
      expect(described_class.call(user.id).first.attributes).to include({ "id" => movie_ranking.id,
                                                                          "user_id" => user.id,
                                                                          "movie_id" => drama_rsx.id,
                                                                          "rank_score" => a_kind_of(BigDecimal),
                                                                          "created_at" => a_kind_of(Time),
                                                                          "updated_at" => a_kind_of(Time)})
    end
  end

  context "when movie ranks do not exist for user" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }
    let(:drama) { create :genre, name: "Drama" }
    let(:comedy) { create :genre, name: "Comedy" }
    let!(:drama_rsx) { create :movie, genre: drama, name: "RSX", movie_range: 57424, id: 179 }

    let!(:preferences) { create :preferred_genre, user: user, genre: comedy }

    before do
      recommended_movies = [
        { "movie_id": 179, "rank_score": 0.945 }
      ]
      stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_movies.json").
        to_return(status: 200, body: recommended_movies.to_json)
    end

    it "creates records" do
      expect { described_class.call(user.id) }.to change(MovieRanking, :count).from(0).to(1)
    end

    it "makes 2 call to database" do
      expect { described_class.call(user.id) }.to make_database_queries(count: 2)
    end

    it "returns correct record structure" do
      expect(described_class.call(user.id).first).to include({ "user_id" => user.id,
                                                               "movie_id" => drama_rsx.id,
                                                               "rank_score" => a_kind_of(BigDecimal) })
    end
  end

  context "when API call returns error" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }
    let(:drama) { create :genre, name: "Drama" }
    let!(:drama_rsx) { create :movie, genre: drama, name: "RSX", movie_range: 57424, id: 179 }

    let!(:preferences) { create :preferred_genre, user: user, genre: drama }

    before do
      stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_movies.json").
        to_return(status: [500, "Internal Server Error"])
    end

    it "does not create records" do
      expect { described_class.call(user.id) }.not_to change(MovieRanking, :count)
    end

    it "works correctly" do
      expect(described_class.call(user.id)).to match_array([])
    end
  end
end
