class Genre < ApplicationRecord
  belongs_to :band
  belongs_to :user, optional: true

  default_scope { order( :genre ) }

  before_save { genre.downcase! }

  validates :genre, presence: true
end
