# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_10_13_064019) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movie_rankings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "movie_id", null: false
    t.decimal "rank_score", precision: 10, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_movie_rankings_on_movie_id"
    t.index ["user_id"], name: "index_movie_rankings_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.bigint "genre_id", null: false
    t.integer "movie_range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_movies_on_genre_id"
  end

  create_table "user_preferred_genres", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_user_preferred_genres_on_genre_id"
    t.index ["user_id"], name: "index_user_preferred_genres_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.int8range "preferred_movie_range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "movies", "genres"
  add_foreign_key "user_preferred_genres", "genres"
  add_foreign_key "user_preferred_genres", "users"
end
