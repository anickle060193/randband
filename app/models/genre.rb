class Genre < ApplicationRecord
  belongs_to :band
  belongs_to :user, optional: true

  before_save { genre.downcase! }

  validates :genre, presence: true
end
