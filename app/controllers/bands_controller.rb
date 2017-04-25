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
                                            .where( "name ILIKE :search", search: "%#{params[ :search ]}%" )
                                            .order( :name )
                                            .page( params[ :custom_page ] ).per( BANDS_PER_PROVIDER_PER_PAGE )

      begin
        offset = ( ( params[ :spotify_page ]&.to_i || 1 ) - 1 ) * BANDS_PER_PROVIDER_PER_PAGE
        spotify_bands = RSpotify::Artist.search( params[ :search ], limit: BANDS_PER_PROVIDER_PER_PAGE, offset: offset )
        converted_spotify_bands = spotify_bands.map { |sb| Band.from_spotify_band( sb, try_find: false ) }
        @bands[ Band::SPOTIFY_PROVIDER ] = Kaminari.paginate_array( converted_spotify_bands, limit: BANDS_PER_PROVIDER_PER_PAGE, offset: offset, total_count: spotify_bands.total )
      rescue RestClient::Unauthorized
        flash.now[ :danger ] = "Something went wrong with the Spotify search. Try again?"
      end
    end

    respond_to( :html, :js )
  end

  def show
  end

  def new
    @band = Band.new
  end

  def create
    Band.transaction do
      @band = Band.new( band_params.except( :genres ) )
      @band.creator = current_user
      @band.provider = Band::CUSTOM_PROVIDER
      @band.provider_id = SecureRandom.urlsafe_base64

      @band.save!
      entered_genres.each do |genre|
        @band.genres << Genre.find_or_create_by!( name: genre )
      end

      flash[ :success ] = "Band created!"
      current_user.like( @band )
      redirect_to band_link( @band )
    end
  rescue ActiveRecord::ActiveRecordError
    render :new
  end

  def edit
  end

  def update
    Band.transaction do
      new_genre_names = entered_genres.map { |s| s.downcase }
      current_genre_names = @band.genres.pluck( :name )

      @band.genres.destroy( Genre.where( name: current_genre_names - new_genre_names ) )

      ( new_genre_names - current_genre_names ).each do |genre|
        @band.genres << Genre.find_or_create_by!( name: genre )
      end

      @band.update!( band_params.except( :genres ) )
      flash[ :success ] = "Band updated"
      redirect_to band_link( @band )
    end
  rescue ActiveRecord::ActiveRecordError
    render :edit
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
      if @band.provider == Band::CUSTOM_PROVIDER
        redirect_back_or band_link( @band ) unless current_user?( @band.creator ) || admin?
      else
        redirect_back_or band_link( @band ) unless admin?
      end
    end

end
