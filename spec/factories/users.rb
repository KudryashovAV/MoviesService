FactoryBot.define do
  factory :user do
    email { "test@test.com" }
    preferred_movie_range { 1..100 }

  end
end
