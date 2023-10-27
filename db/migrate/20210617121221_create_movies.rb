class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :name
      t.integer :year
      t.references :genre, null: false, foreign_key: true
      t.integer :movie_range

      t.timestamps
    end
  end
end
