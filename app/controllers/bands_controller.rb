class BandsController < ApplicationController

  def index
    if params[ :search ].blank?
      @bands = [ ]
    else
      @bands = RSpotify::Artist.search( params[ :search ], limit: 20 )
    end
  end

  def show
    @band = RSpotify::Artist.find( params[ :id ] )
  end

end
