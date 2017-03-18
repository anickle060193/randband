class CreateBands < ActiveRecord::Migration[5.0]
  def change
    create_table :bands do |t|
      t.string :name, null: false
      t.string :provider, null: false
      t.string :provider_id, null: false
      t.string :thumbnail
      t.string :external_url
      t.belongs_to :user, foreign_key: true, index: true


      t.timestamps
    end
    add_index :bands, [ :provider, :provider_id ]
  end
end
