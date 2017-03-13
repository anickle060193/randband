class BandsController < ApplicationController

  def index
    if params[ :search ].blank?
      @bands = [ ]
    else
      @bands = RSpotify::Artist.search( params[ :search ], limit: 20 ).map { |spotify_band| SpotifyBand.new( spotify_band ) }
    end
  end

  def show
    provider = params[ :provider ]
    if provider == "spotify"
      spotify_artist = RSpotify::Artist.find( params[ :id ] )
      if spotify_artist.nil?
        not_found( "Spotify artist could not be found." )
      else
        @band = SpotifyBand.new( spotify_artist )
      end
    else
      not_found( "Band provider not included." )
    end
  end

end
