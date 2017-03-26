class Band < ApplicationRecord
  has_many :band_likes, dependent: :destroy
  has_many :users, through: :band_likes
  belongs_to :user, optional: true
  has_many :genres, dependent: :destroy

  scope :order_by_name, -> { order( "LOWER( name )" ) }

  validates :name, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :provider_id, presence: true, uniqueness: { scope: :provider }
  validates :thumbnail, url: true
  validates :external_url, url: true
  validates :user_id, presence: true, if: Proc.new { |band| band.provider == CUSTOM_PROVIDER }

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
    if b.nil?
      b = Band.new
      b.name = spotify_band.name
      b.provider = SPOTIFY_PROVIDER
      b.provider_id = spotify_band.id
      image = spotify_band.images.first
      b.thumbnail = image[ "url" ] if !image.nil?
      b.external_url = spotify_band.external_urls[ "spotify" ]
      spotify_band.genres.each { |g| b.genres.build( genre: g ) }
    end
    return b
  end

end
