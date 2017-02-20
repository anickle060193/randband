class Band < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :link, presence: true
  validate :valid_link_scheme

  private

    def valid_link_scheme
      if errors[ :link ].empty?
        uri = URI( link )
        if !%w{ http, https }.include?( uri.scheme )
          errors.add( :link, "must be http or https." )
        elsif !uri.host || uri.host.empty?
          errors.add( :link, "is invalid." )
        end
      end
    end

end
