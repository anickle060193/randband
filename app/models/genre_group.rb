class GenreGroup < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :genre_entries
  has_many :genres, through: :genre_entries, dependent: :destroy
  has_many :bands, through: :genres

  default_scope { order( :name ) }

  before_validation { name.downcase! }

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
end
