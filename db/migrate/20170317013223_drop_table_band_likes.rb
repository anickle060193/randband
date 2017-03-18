class DropTableBandLikes < ActiveRecord::Migration[5.0]
  def change
    drop_table :band_likes
  end
end
