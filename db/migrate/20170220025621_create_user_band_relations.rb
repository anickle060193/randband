class CreateUserBandRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_band_relations do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :band, foreign_key: true

      t.timestamps
    end
    add_index :user_band_relations, [ :user_id, :band_id ], unique: true
  end
end
