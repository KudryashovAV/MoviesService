class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.int8range :preferred_movie_range

      t.timestamps
    end
  end
end
