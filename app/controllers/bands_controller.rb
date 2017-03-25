class BandsController < ApplicationController
  before_action :find_band_by_provider, only: [ :show, :edit ]
  before_action :find_band_by_id, only: [ :update, :destroy ]
  before_action :logged_in_user, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :correct_user, only: [ :edit, :update, :destroy ]

  BANDS_PER_PROVIDER_PER_PAGE = 12

  def index
    @titles = [ "Spotify Bands", "User Created Bands" ]
    @providers = [ Band::SPOTIFY_PROVIDER, Band::CUSTOM_PROVIDER ]

    params[ :provider ] = @providers.first unless @providers.include?( params[ :provider ] )

    @bands = { }

    if params[ :search ].present?
      @bands[ Band::CUSTOM_PROVIDER ] = Band.where( provider: Band::CUSTOM_PROVIDER )
                                            .where( "name LIKE :search", search: "%#{params[ :search ]}%" )
                                            .order_by_name
                                            .paginate( page: params[ :custom_page ] || 1, per_page: BANDS_PER_PROVIDER_PER_PAGE )

      @bands[ Band::SPOTIFY_PROVIDER ] = WillPaginate::Collection.create( params[ :spotify_page ] || 1, BANDS_PER_PROVIDER_PER_PAGE ) do |pager|
        begin
          spotify_bands = RSpotify::Artist.search( params[ :search ], limit: pager.per_page, offset: pager.offset )
          pager.replace( spotify_bands.map { |spotify_band| Band.from_spotify_band( spotify_band ) } )
          pager.total_entries ||= spotify_bands.total
        rescue RestClient::Unauthorized
          flash.now[ :danger ] = "Something went wrong with the search. Try again?"
        end
      end
    end
  end

  def show
  end

  def new
    @band = Band.new
  end

  def create
    @band = Band.new( band_params.except( :genres ) )
    @band.user = current_user
    @band.provider = Band::CUSTOM_PROVIDER
    @band.provider_id = SecureRandom.urlsafe_base64

    if @band.save
      entered_genres.each do |genre|
        @band.genres.create( genre: genre, user: current_user )
      end

      flash[ :success ] = "Band created!"
      current_user.bands << @band
      redirect_to band_link( @band )
    else
      render :new
    end
  end

  def edit
  end

  def update
    new_genre_names = entered_genres.map { |s| s.downcase }
    current_genre_names = @band.genres.where( user: current_user ).order( :genre ).pluck( :genre )

    @band.genres.where( genre: current_genre_names - new_genre_names ).destroy_all

    ( new_genre_names - current_genre_names ).each do |genre|
      @band.genres.create!( genre: genre, user: current_user )
    end

    if @band.update( band_params.except( :genres ) )
      flash[ :success ] = "Band updated"
      redirect_to band_link( @band )
    else
      render :edit
    end
  end

  def destroy
    @band.destroy!
    flash[ :info ] = "Band deleted"
    redirect_to bands_url
  end

  private

    def band_params
      params.require( :band ).permit( :name, :thumbnail, :external_url, :genres )
    end

    def find_band_by_provider
      @band = Band.find_by_provider( params[ :provider ], params[ :provider_id ] )
    rescue RestClient::Unauthorized
      flash[ :warning ] = "Could not find band. Try again?"
      redirect_to bands_url
    end

    def find_band_by_id
      @band = Band.find( params[ :id ] )
    end

    def entered_genres
      band_params[ :genres ].split( /\r?\n/ )
    end

    def correct_user
      band = Band.find_by( id: params[ :id ] )
      band ||= Band.find_by_provider( params[ :provider ], params[ :provider_id ] )
      redirect_to band_link( band ) unless current_user?( band.user )
    end

end
