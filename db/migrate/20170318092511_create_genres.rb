class CreateGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :genres do |t|
      t.text :genre, index: true, null: false
      t.belongs_to :band, foreign_key: true, index: true, null: false
      t.belongs_to :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
