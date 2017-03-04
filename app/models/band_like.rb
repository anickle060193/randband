class BandLike < ApplicationRecord
  belongs_to :user

  validates :spotify_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :user_id, scope: :spotify_id
end
