require "rails_helper"

describe MovieRanking do
  let(:user) { create :user }
  let(:raw_data) { [{ "user_id" => user.id, "movie_id" => 179, "rank_score" => 0.675 },
                    { "user_id" => user.id, "movie_id" => 179, "rank_score" => 0.675 }] }

  it "creates records in batch " do
    expect { described_class.insert_all(raw_data, returning: [:id]) }
      .to change(MovieRanking, :count).from(0).to(2)
  end
end
