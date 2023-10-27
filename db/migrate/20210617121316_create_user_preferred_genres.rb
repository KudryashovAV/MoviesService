class CreateUserPreferredGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :user_preferred_genres do |t|
      t.references :user, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
