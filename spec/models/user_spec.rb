require "rails_helper"

describe User do
  let(:user) { create :user }
  let(:drama) { create :genre, name: "Drama" }
  let(:comedy) { create :genre, name: "Comedy" }

  let!(:preferences1) { create :preferred_genre, user: user, genre: drama }
  let!(:preferences2) { create :preferred_genre, user: user, genre: comedy }

  it "has relation to preferred genres" do
    expect(user.user_preferred_genres.pluck(:id)).to match_array([drama.id, comedy.id])
  end
end
