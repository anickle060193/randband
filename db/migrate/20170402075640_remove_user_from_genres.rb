class RemoveUserFromGenres < ActiveRecord::Migration[5.0]
  def change
    remove_reference :genres, :user, foreign_key: true
  end
end
