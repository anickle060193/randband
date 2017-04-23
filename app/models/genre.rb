class Genre < ApplicationRecord
  has_many :band_genres
  has_many :bands, through: :band_genres, dependent: :destroy
  has_many :genre_entries
  has_many :genre_groups, through: :genre_entries, dependent: :destroy

  default_scope { order( :name ) }

  before_validation { name.downcase! }

  validates :name, presence: true, uniqueness: true
end
