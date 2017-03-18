class MakeBandProviderProviderIdUnique < ActiveRecord::Migration[5.0]
  def change
    remove_index :bands, [ :provider, :provider_id ]
    add_index :bands, [ :provider, :provider_id ], unique: true
  end
end
