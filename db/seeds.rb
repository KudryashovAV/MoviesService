GENRES_DATA = %w[Anime Biographical Action Western Military Detective Children Documentary Drama Historical Comedy
                 Concert Short Crime Melodrama Mysticism Music Cartoon Musical Science Noir Adventure Reality-Show
                 Family Sports Talk-Show Thriller Horror Science Fantasy]

MOVIES_DATA = JSON.parse(File.read("db/movies.json"))

GENRES = GENRES_DATA.each.with_object({}) do |name, memo|
  memo["genre_name"] = Genre.create!(name: name)
end

MOVIES_DATA.each do |movie_item|
  Movie.create!(
    name: movie_item["name"],
    genre: GENRES[movie_item["genre_name"]],
    year: movie_item["year"],
    movie_range: rand(100)
  )
end

User.create!(
  email: "example@mail.com",
  preferred_movie_range: 35_000...40_000,
  user_preferred_genres: [GENRES["Drama"], GENRES["Action"]],
)
