require "rails_helper"

describe Genre do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:comedy) { create :genre, name: "Comedy" }

  let!(:preferences1) { create :preferred_genre, user: user1, genre: comedy }
  let!(:preferences2) { create :preferred_genre, user: user2, genre: comedy }

  it "has relation to user preferred genres" do
    expect(comedy.genre_preferred_users.pluck(:id)).to match_array([user1.id, user2.id])
  end
end
