class CreateGenreGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :genre_groups do |t|
      t.string :name, null: false, index: true
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
      t.index [ :name, :user_id ], unique: true
    end
  end
end
