class BandLike < ApplicationRecord
  belongs_to :user
  belongs_to :band

  validates :user_id, presence: true
  validates :band_id, presence: true
  validates_uniqueness_of :band_id, scope: :user_id
end
