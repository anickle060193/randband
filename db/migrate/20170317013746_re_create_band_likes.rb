class ReCreateBandLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :band_likes do |t|
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.belongs_to :band, foreign_key: true, null: false, index: true
    end
    add_index :band_likes, [ :user_id, :band_id ], unique: true
  end
end
