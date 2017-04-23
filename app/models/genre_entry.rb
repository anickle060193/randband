class GenreEntry < ApplicationRecord
  belongs_to :genre
  belongs_to :genre_group

  validates :genre_id, presence: true, uniqueness: { scope: :genre_group_id }
  validates :genre_group_id, presence: true
end
