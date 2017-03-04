class CreateBandLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :band_likes do |t|
      t.belongs_to :user
      t.string :spotify_id, index: true
    end
    add_index :band_likes, [ :user_id, :spotify_id ], unique: true
  end
end
