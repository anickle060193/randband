class Band < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id", optional: true
  has_many :band_likes
  has_many :followers, through: :band_likes, source: :user, dependent: :destroy
  has_many :band_genres
  has_many :genres, through: :band_genres, dependent: :destroy
  has_many :genre_groups, through: :genres

  default_scope { order( :name ) }

  validates :name, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :provider_id, presence: true, uniqueness: { scope: :provider }
  validates :thumbnail, url: true
  validates :external_url, url: true
  validates :user_id, presence: true, if: Proc.new { |band| band.provider == CUSTOM_PROVIDER }, on: :create

  CUSTOM_PROVIDER = "custom"
  SPOTIFY_PROVIDER = "spotify"

  PROVIDERS = [ CUSTOM_PROVIDER, SPOTIFY_PROVIDER ]

  def self.find_by_provider( provider, provider_id )
    b = Band.find_by( provider: provider, provider_id: provider_id )
    return b unless b.nil?

    if provider == SPOTIFY_PROVIDER
      spotify_band = RSpotify::Artist.find( provider_id )
      return Band.from_spotify_band( spotify_band, try_find: false )
    else
      raise ArgumentError.new( "Invalid provider: '#{provider}' - ID: '#{provider_id}'" )
    end
  end

  def self.from_spotify_band( spotify_band, try_find: true )
    b = Band.find_by( provider: SPOTIFY_PROVIDER, provider_id: spotify_band.id ) if try_find
    return b unless b.nil?

    b = Band.new
    b.name = spotify_band.name
    b.provider = SPOTIFY_PROVIDER
    b.provider_id = spotify_band.id
    image = spotify_band.images.first
    b.thumbnail = image[ "url" ] if !image.nil?
    b.external_url = spotify_band.external_urls[ "spotify" ]
    spotify_band.genres.each { |g| b.genres << Genre.find_or_initialize_by( name: g ) }
    return b
  end

  def self.find_or_create_by_provider( provider, provider_id )
    b = Band.find_by( provider: provider, provider_id: provider_id )
    return b unless b.nil?

    if provider == SPOTIFY_PROVIDER
      spotify_band = RSpotify::Artist.find( provider_id )
      return Band.find_or_create_from_spotify_band( spotify_band, try_find: false )
    else
      raise ArgumentError.new( "Invalid provider: '#{provider}' - ID: '#{provider_id}'" )
    end
  end

  def self.find_or_create_from_spotify_band( spotify_band, try_find: true )
    b = Band.find_by( provider: SPOTIFY_PROVIDER, provider_id: spotify_band.id ) if try_find
    return b unless b.nil?

    Band.transaction do
      b = Band.new
      b.name = spotify_band.name
      b.provider = SPOTIFY_PROVIDER
      b.provider_id = spotify_band.id
      image = spotify_band.images.first
      b.thumbnail = image[ "url" ] if !image.nil?
      b.external_url = spotify_band.external_urls[ "spotify" ]
      b.save!
      spotify_band.genres.each { |g| b.genres << Genre.find_or_create_by!( name: g ) }
      return b
    end
  end

end
