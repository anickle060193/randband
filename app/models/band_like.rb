class BandLike < ApplicationRecord
  belongs_to :user
  belongs_to :band

  validates :user_id, presence: true
  validates :band_id, presence: true
  validates :band_id, uniqueness: { scope: :user_id, message: "for Band and User already exists" }
end
