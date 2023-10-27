class CreateMovieRankingsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :movie_rankings do |t|
      t.references :user, null: false
      t.references :movie, null: false
      t.decimal :rank_score, precision: 10, scale: 10

      t.timestamps
    end
  end
end
