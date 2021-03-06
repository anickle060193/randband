class UsersController < ApplicationController
  before_action :find_user, only: [ :show, :edit, :update, :adminify, :destroy ]
  before_action :logged_in_user, only: [ :edit, :update, :spotify ]
  before_action :correct_user, only: [ :edit, :update ]
  before_action :admin_user, only: [ :adminify, :destroy ]

  LIST_GROUP_ITEMS_PER_PAGE = 5

  def show
    @liked_bands = @user.liked_bands.order( :name ).page( params[ :liked_bands_page ] ).per( LIST_GROUP_ITEMS_PER_PAGE )
    @created_bands = @user.created_bands.order( :name ).page( params[ :created_bands_page ] ).per( LIST_GROUP_ITEMS_PER_PAGE )
    @genre_groups = @user.genre_groups.order( :name ).page( params[ :genre_groups_page ] ).per( LIST_GROUP_ITEMS_PER_PAGE )
    if current_user?( @user ) && @user.email.present? && !@user.activated
      flash.now[ :warning ] = "Account has not been activated. Check your email for the activation link."
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new( create_user_params )
    if @user.save
      log_in @user
      if @user.email.present?
        @user.send_activation_email
        flash[ :info ] = "Please check your email to activate your account."
      end
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    old_email = @user.email
    if @user.update( update_user_params )
      flash[ :success ] = "Profile updated"
      if @user.email.present? && ( old_email != @user.email )
        @user.update( activated: false )
        @user.send_activation_email
      end
      redirect_to @user
    else
      render :edit
    end
  end

  def adminify
    @user.update( admin: true ) unless @user.admin?
    redirect_back_or @user
  end

  def destroy
    @user.destroy!
    flash[ :info ] = "User deleted."
    redirect_back_or root_url
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
      unless current_user.liked_bands.find_by( provider: Band::SPOTIFY_PROVIDER, provider_id: spotify_band.id )
        band = Band.find_or_create_from_spotify_band( spotify_band )
        current_user.like( band )
        added_count += 1
      end
    end

    flash[ added_count > 0 ? :success : :info ] = "Added #{ added_count } new #{ "band".pluralize( added_count ) }."
    redirect_to current_user
  end

  private

    def find_user
      @user = User.find_by!( username: params[ :id ] )
    end

    def create_user_params
      params.require( :user ).permit( :username, :email, :password, :password_confirmation )
    end

    def update_user_params
      params.require( :user ).permit( :email, :password, :password_confirmation )
    end

    def correct_user
      redirect_back_or( @user ) unless ( current_user?( @user ) || ( admin? && !@user.admin? ) )
    end

    def admin_user
      redirect_back_or( @user ) if ( !admin? || @user.admin? )
    end

end
