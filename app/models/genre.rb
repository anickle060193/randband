class Genre < ApplicationRecord
  default_scope { order( :name ) }

  before_save { name.downcase! }

  validates :name, presence: true
end
