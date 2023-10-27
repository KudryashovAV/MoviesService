FactoryBot.define do
  factory :preferred_genre do
    association :genre
    association :user
  end
end
