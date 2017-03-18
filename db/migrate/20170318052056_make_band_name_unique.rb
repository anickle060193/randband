class MakeBandNameUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :bands, :name, unique: true
  end
end
