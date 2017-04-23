class BandGenre < ApplicationRecord
  belongs_to :band
  belongs_to :genre

  validates :band_id, presence: true
  validates :genre_id, presence: true
  validates :genre_id, uniqueness: { scope: :band_id, message: "for Genre and Band already exists" }
end
