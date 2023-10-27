FactoryBot.define do
  factory :movie do
    name { "testname" }
    year { 1946 }
    movie_range { 100 }

    association :genre
  end
end
