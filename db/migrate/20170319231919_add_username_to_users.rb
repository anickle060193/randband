class AddUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true

    reversible do |dir|
      dir.up do
        User.update_all( 'username = email' )
        change_column :users, :username, :string, null: false
      end
    end

  end
end
