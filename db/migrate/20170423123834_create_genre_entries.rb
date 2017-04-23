class CreateGenreEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :genre_entries do |t|
      t.belongs_to :genre, foreign_key: true, null: false
      t.belongs_to :genre_group, foreign_key: true, null: false

      t.timestamps
      t.index [ :genre_id, :genre_group_id ], unique: true
    end
  end
end
