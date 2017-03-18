class UsersController < ApplicationController
  before_action :logged_in_user, only: [ :edit, :update, :spotify ]
  before_action :correct_user, only: [ :edit, :update ]
  before_action :admin_user, only: [ :destroy ]

  def show
    @user = User.find( params[ :id ] )
    @bands = @user.bands.order_by_name.paginate( page: params[ :bands_page ], per_page: 8 )
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new( user_params )
    if @user.save
      @user.send_activation_email
      flash[ :info ] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find( params[ :id ] )
  end

  def update
    @user = User.find( params[ :id ] )
    if @user.update_attributes( user_params )
      flash[ :success ] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find( params[ :id ] ).destroy
    flash[ :info ] = "User deleted."
    redirect_to users_url
  end

  def spotify
    spotify_user = RSpotify::User.new( request.env[ "omniauth.auth" ] )

    after = 0
    spotify_bands = [ ]

    loop do
      found = spotify_user.following( type: "artist", limit: 30, after: after )

      break if found.empty?

      spotify_bands += found
      after += found.length
    end

    spotify_bands.uniq! { |spotify_band| spotify_band.id }

    added_count = 0

    spotify_bands.each do |spotify_band|
      unless current_user.bands.find_by( provider: Band::SPOTIFY_PROVIDER, provider_id: spotify_band.id )
        band = Band.from_spotify_band( spotify_band )
        current_user.like( band )
        added_count += 1
      end
    end

    flash[ added_count > 0 ? :success : :info ] = "Added #{ added_count } new #{ "band".pluralize( added_count ) }."
    redirect_to current_user
  end

  private

    def user_params
      params.require( :user ).permit( :name, :email, :password, :password_confirmation )
    end

    def correct_user
      @user = User.find( params[ :id ] )
      redirect_to( @user ) unless current_user?( @user )
    end

    def admin_user
      redirect_to( root_url ) unless admin?
    end

end
