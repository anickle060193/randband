class SpotifyBand
  attr_reader :id, :provider, :name, :thumbnail, :external_url, :genres

  def initialize( artist )
    if !artist.is_a?( RSpotify::Artist )
      raise ArgumentError.new( "Spotify artist not found." )
    end

    @spotify_band = artist
  end

  def provider
    "spotify"
  end

  def id
   @spotify_band.id
  end

  def name
    @spotify_band.name
  end

  def thumbnail
    @spotify_band.images.first[ "url" ]
  end

  def external_url
    @spotify_band.external_urls[ "spotify" ]
  end

  def genres
    @spotify_band.genres
  end

end
