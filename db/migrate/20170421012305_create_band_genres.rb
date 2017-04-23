class CreateBandGenres < ActiveRecord::Migration[5.0]
  def change

    create_table :band_genres do |t|
      t.belongs_to :band, foreign_key: true, null: false
      t.belongs_to :genre, foreign_key: true, null: false

      t.timestamps

      t.index [ :band_id, :genre_id ], unique: true
    end

    rename_column :genres, :genre, :name
    change_column_null :genres, :band_id, true
    add_column :genres, :new, :boolean, default: false

    reversible do |dir|
      dir.up do

        execute <<-SQL.squish
          INSERT INTO genres ( name, new, created_at, updated_at )
          SELECT DISTINCT genres.name, TRUE, NOW(), NOW()
          FROM genres
          WHERE genres.new = FALSE
        SQL

        execute <<-SQL.squish
          INSERT INTO band_genres ( band_id, genre_id, created_at, updated_at )
          SELECT
            genres.band_id AS band_id,
            ( SELECT genres2.id FROM genres AS genres2 WHERE genres.name = genres2.name AND genres2.new = TRUE LIMIT 1 ) as genre_id,
            genres.created_at AS created_at,
            genres.updated_at AS updated_at
          FROM genres
          WHERE genres.new = FALSE
        SQL

        execute <<-SQL.squish
          DELETE FROM genres
          WHERE genres.new = FALSE
        SQL

      end

      dir.down do
        execute <<-SQL.squish
          INSERT INTO genres ( name, band_id, new, created_at, updated_at )
          SELECT
            ( SELECT genres.name FROM genres WHERE genres.id = band_genres.genre_id LIMIT 1 ) AS name,
            band_genres.band_id AS band_id,
            TRUE AS new,
            band_genres.created_at AS created_at,
            band_genres.updated_at AS updated_at
          FROM band_genres
        SQL

        execute <<-SQL.squish
          DELETE FROM band_genres
        SQL

        execute <<-SQL.squish
          DELETE FROM genres
          WHERE genres.new = FALSE
        SQL
      end
    end

    remove_column :genres, :new, :boolean, default: false
    remove_belongs_to :genres, :band, foreign_key: true, index: true, null: true
    remove_index :genres, :name
    add_index :genres, :name, unique: true

  end
end
