class UsersController < ApplicationController
  before_action :logged_in_user, only: [ :edit, :update, :spotify ]
  before_action :correct_user, only: [ :edit, :update ]
  before_action :admin_user, only: [ :destroy ]

  def show
    @user = User.find( params[ :id ] )
    @band_likes = @user.band_likes.paginate( page: params[ :bands_page ], per_page: 8 )
    if @band_likes.any?
      @bands = RSpotify::Artist.find( @band_likes.map { |band_like| band_like.spotify_id } )
    else
      @bands = [ ]
    end
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
      render 'new'
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
      render 'edit'
    end
  end

  def destroy
    User.find( params[ :id ] ).destroy
    flash[ :success ] = "User deleted."
    redirect_to users_url
  end

  def spotify
    spotify_user = RSpotify::User.new( request.env[ "omniauth.auth" ] )

    after = 0
    spotify_ids = [ ]

    loop do
      puts after
      artists = spotify_user.following( type: "artist", limit: 30, after: after )

      break if artists.empty?

      after += artists.length
      artists.each do |artist|
        unless current_user.like?( artist.id ) or spotify_ids.include?( artist.id )
          spotify_ids << artist.id
        end
      end
    end

    spotify_ids.each do |spotify_id|
      current_user.band_likes.create( spotify_id: spotify_id )
    end

    added_count = spotify_ids.length
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
