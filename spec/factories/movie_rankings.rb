FactoryBot.define do
  factory :movie_ranking do
    rank_score { 0.0001 }
    association :movie
    association :user
  end
end
