class BandsController < ApplicationController

  def index
    @bands = [ ]
    if !params[ :search ].blank?
      begin
        spotify_bands = RSpotify::Artist.search( params[ :search ], limit: 20 )
        @bands = spotify_bands.map { |spotify_band| Band.from_spotify_band( spotify_band ) }
      rescue RestClient::Unauthorized => error
        @bands = [ ]
        flash.now[ :danger ] = "Something went wrong with the search. Try again?"
      end
    end
  end

  def show
    @band = Band.find_by_provider( params[ :provider ], params[ :provider_id ] )
  end

end
