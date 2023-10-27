require "rails_helper"

describe MoviesController, type: :controller do
  before do
    recommended_movies = [
      { "movie_id": 179, "rank_score": 0.945 },
      { "movie_id": 5, "rank_score": 0.4552 },
      { "movie_id": 13, "rank_score": 0.567 },
      { "movie_id": 97, "rank_score": 0.9489 },
      { "movie_id": 32, "rank_score": 0.0967 },
      { "movie_id": 176, "rank_score": 0.0353 },
      { "movie_id": 177, "rank_score": 0.1657 },
      { "movie_id": 36, "rank_score": 0.7068 },
      { "movie_id": 103, "rank_score": 0.4729 }
    ]
    stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_movies.json").
      to_return(status: 200, body: recommended_movies.to_json)
  end

  after do
    WebMock.reset_executed_requests!
  end

  context "invalid request" do
    it "has bad request status" do
      get :index
      expect(response.status).to eq(400)
    end

    it "has error in body" do
      get :index
      expect(JSON.parse(response.body)).to eq({ "error" => "'user_id' parameter is required" })
    end
  end

  context "valid request" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }

    let(:drama) { create :genre, name: "Drama" }
    let(:comedy) { create :genre, name: "Comedy" }

    let!(:drama_rsx) { create :movie, genre: drama, model: "RSX", movie_range: 57424, id: 179 }
    let!(:drama_mdx) { create :movie, genre: drama, model: "MDX", movie_range: 47424, id: 8 }
    let!(:drama_ilx) { create :movie, genre: drama, model: "ILX", movie_range: 37424, id: 54 }

    let!(:comedy_rsx) { create :movie, genre: comedy, model: "X6", movie_range: 58424, id: 13 }
    let!(:comedy_mdx) { create :movie, genre: comedy, model: "X5", movie_range: 147424, id: 45 }
    let!(:comedy_ilx) { create :movie, genre: comedy, model: "X4", movie_range: 137424, id: 5 }

    let!(:preferences) { create :preferred_genre, user: user, genre: comedy }

    it "calls movieRankingFetcher" do
      expect(Movies::RankingFetcher).to receive(:call).with(user.id.to_s).once
      get :index, params: { user_id: user.id }
    end

    it "has good request status" do
      get :index, params: { user_id: user.id }
      expect(response.status).to eq(200)
    end

    it "has correct response" do
      get :index, params: { user_id: user.id }
      expect(JSON.parse(response.body)).to eq([
        {
          "genre" => {
            "id" => comedy.id,
            "name" => "Comedy"
          },
          "id" => 13,
          "label" => "perfect_match",
          "model" => "X6",
          "movie_range" => 58424,
          "rank_score" => 0.567
        },
        {
          "genre" => {
            "id" => comedy.id,
            "name" => "Comedy"
          },
          "id" => 5,
          "label" => "good_match",
          "model" => "X4",
          "movie_range" => 137424,
          "rank_score" => 0.4552
        },
        {
          "genre" => {
            "id" => comedy.id,
            "name" => "Comedy"
          },
          "id" => 45,
          "label" => "good_match",
          "model" => "X5",
          "movie_range" => 147424,
          "rank_score" => nil
        },
        {
          "genre" => {
            "id" => drama.id,
            "name" => "Drama"
          },
          "id" => 179,
          "label" => nil,
          "model" => "RSX",
          "movie_range" => 57424,
          "rank_score" => 0.945
        },
        {
          "genre" => {
            "id" => drama.id,
            "name" => "Drama"
          },
          "id" => 54,
          "label" => nil,
          "model" => "ILX",
          "movie_range" => 37424,
          "rank_score" => nil
        },
        {
          "genre" => {
            "id" => drama.id,
            "name" => "Drama"
          },
          "id" => 8,
          "label" => nil,
          "model" => "MDX",
          "movie_range" => 47424,
          "rank_score" => nil
        },
      ])
    end
  end

  context "valid request with user id and genre name" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }

    let(:drama) { create :genre, name: "Drama" }
    let(:comedy) { create :genre, name: "Comedy" }

    let!(:drama_rsx) { create :movie, genre: drama, model: "RSX", movie_range: 57424, id: 179 }
    let!(:drama_mdx) { create :movie, genre: drama, model: "MDX", movie_range: 47424, id: 8 }
    let!(:drama_ilx) { create :movie, genre: drama, model: "ILX", movie_range: 37424, id: 54 }

    let!(:comedy_rsx) { create :movie, genre: comedy, model: "X6", movie_range: 157424, id: 13 }
    let!(:comedy_mdx) { create :movie, genre: comedy, model: "X5", movie_range: 147424, id: 45 }
    let!(:comedy_ilx) { create :movie, genre: comedy, model: "X4", movie_range: 137424, id: 5 }

    let!(:preferences) { create :preferred_genre, user: user, genre: comedy }

    it "has correct response" do
      get :index, params: { user_id: user.id, query: "Acu" }
      expect(JSON.parse(response.body)).to eq([{
                                                 "genre" => {
                                                   "id" => drama.id,
                                                   "name" => "Drama"
                                                 },
                                                 "id" => 179,
                                                 "label" => nil,
                                                 "model" => "RSX",
                                                 "movie_range" => 57424,
                                                 "rank_score" => 0.945
                                               },
                                               {
                                                 "genre" => {
                                                   "id" => drama.id,
                                                   "name" => "Drama"
                                                 },
                                                 "id" => 54,
                                                 "label" => nil,
                                                 "model" => "ILX",
                                                 "movie_range" => 37424,
                                                 "rank_score" => nil
                                               },
                                               {
                                                 "genre" => {
                                                   "id" => drama.id,
                                                   "name" => "Drama"
                                                 },
                                                 "id" => 8,
                                                 "label" => nil,
                                                 "model" => "MDX",
                                                 "movie_range" => 47424,
                                                 "rank_score" => nil
                                               },])
    end
  end

  context "valid request with user id and min movie_range" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }

    let(:drama) { create :genre, name: "Drama" }
    let(:comedy) { create :genre, name: "Comedy" }

    let!(:drama_rsx) { create :movie, genre: drama, model: "RSX", movie_range: 57424, id: 179 }
    let!(:drama_mdx) { create :movie, genre: drama, model: "MDX", movie_range: 157424, id: 8 }
    let!(:drama_ilx) { create :movie, genre: drama, model: "ILX", movie_range: 37424, id: 54 }

    let!(:comedy_rsx) { create :movie, genre: comedy, model: "X6", movie_range: 57424, id: 13 }
    let!(:comedy_mdx) { create :movie, genre: comedy, model: "X5", movie_range: 147424, id: 45 }
    let!(:comedy_ilx) { create :movie, genre: comedy, model: "X4", movie_range: 137424, id: 5 }

    let!(:preferences) { create :preferred_genre, user: user, genre: comedy }

    it "has correct response" do
      get :index, params: { user_id: user.id, movie_range_min: 100_000 }
      expect(JSON.parse(response.body)).to eq([
                                                {
                                                  "genre" => {
                                                    "id" => comedy.id,
                                                    "name" => "Comedy"
                                                  },
                                                  "id" => 5,
                                                  "label" => "good_match",
                                                  "model" => "X4",
                                                  "movie_range" => 137424,
                                                  "rank_score" => 0.4552
                                                },
                                                {
                                                  "genre" => {
                                                    "id" => comedy.id,
                                                    "name" => "Comedy"
                                                  },
                                                  "id" => 45,
                                                  "label" => "good_match",
                                                  "model" => "X5",
                                                  "movie_range" => 147424,
                                                  "rank_score" => nil
                                                },
                                                {
                                                  "genre" => {
                                                    "id" => drama.id,
                                                    "name" => "Drama"
                                                  },
                                                  "id" => 8,
                                                  "label" => nil,
                                                  "model" => "MDX",
                                                  "movie_range" => 157424,
                                                  "rank_score" => nil
                                                },
                                              ])
    end
  end

  context "valid request with user id and max movie_range" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }

    let(:drama) { create :genre, name: "Drama" }
    let(:comedy) { create :genre, name: "Comedy" }

    let!(:drama_rsx) { create :movie, genre: drama, model: "RSX", movie_range: 57424, id: 179 }
    let!(:drama_mdx) { create :movie, genre: drama, model: "MDX", movie_range: 47424, id: 8 }
    let!(:drama_ilx) { create :movie, genre: drama, model: "ILX", movie_range: 37424, id: 54 }

    let!(:comedy_rsx) { create :movie, genre: comedy, model: "X6", movie_range: 58424, id: 13 }
    let!(:comedy_mdx) { create :movie, genre: comedy, model: "X5", movie_range: 147424, id: 45 }
    let!(:comedy_ilx) { create :movie, genre: comedy, model: "X4", movie_range: 137424, id: 5 }

    let!(:preferences) { create :preferred_genre, user: user, genre: comedy }

    it "has correct response" do
      get :index, params: { user_id: user.id, movie_range_max: 100_000 }
      expect(JSON.parse(response.body)).to eq([
                                                {
                                                  "genre" => {
                                                    "id" => comedy.id,
                                                    "name" => "Comedy"
                                                  },
                                                  "id" => 13,
                                                  "label" => "perfect_match",
                                                  "model" => "X6",
                                                  "movie_range" => 58424,
                                                  "rank_score" => 0.567
                                                },
                                                {
                                                  "genre" => {
                                                    "id" => drama.id,
                                                    "name" => "Drama"
                                                  },
                                                  "id" => 179,
                                                  "label" => nil,
                                                  "model" => "RSX",
                                                  "movie_range" => 57424,
                                                  "rank_score" => 0.945
                                                },
                                                {
                                                  "genre" => {
                                                    "id" => drama.id,
                                                    "name" => "Drama"
                                                  },
                                                  "id" => 54,
                                                  "label" => nil,
                                                  "model" => "ILX",
                                                  "movie_range" => 37424,
                                                  "rank_score" => nil
                                                },
                                                {
                                                  "genre" => {
                                                    "id" => drama.id,
                                                    "name" => "Drama"
                                                  },
                                                  "id" => 8,
                                                  "label" => nil,
                                                  "model" => "MDX",
                                                  "movie_range" => 47424,
                                                  "rank_score" => nil
                                                },
                                              ])
    end
  end

  context "valid request with user id, genre name, min movie_range, and max movie_range" do
    let(:user) { create :user, preferred_movie_range: 1_000..100_000 }

    let(:drama) { create :genre, name: "Drama" }
    let(:comedy) { create :genre, name: "Comedy" }

    let!(:drama_rsx) { create :movie, genre: drama, model: "RSX", movie_range: 57424, id: 179 }
    let!(:drama_mdx) { create :movie, genre: drama, model: "MDX", movie_range: 47424, id: 8 }
    let!(:drama_ilx) { create :movie, genre: drama, model: "ILX", movie_range: 37424, id: 54 }

    let!(:comedy_rsx) { create :movie, genre: comedy, model: "X6", movie_range: 58424, id: 13 }
    let!(:comedy_mdx) { create :movie, genre: comedy, model: "X5", movie_range: 147424, id: 45 }
    let!(:comedy_ilx) { create :movie, genre: comedy, model: "X4", movie_range: 137424, id: 5 }

    let!(:preferences) { create :preferred_genre, user: user, genre: comedy }

    it "has correct response" do
      get :index, params: { user_id: user.id, query: "Acu", movie_range_min: 50_000, movie_range_max: 60_000  }
      expect(JSON.parse(response.body)).to eq([
                                                {
                                                  "genre" => {
                                                    "id" => drama.id,
                                                    "name" => "Drama"
                                                  },
                                                  "id" => 179,
                                                  "label" => nil,
                                                  "model" => "RSX",
                                                  "movie_range" => 57424,
                                                  "rank_score" => 0.945
                                                }
                                              ])
    end
  end
end
