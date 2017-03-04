class BandLikesController < ApplicationController
  before_action :logged_in_user, only: [ :create, :destroy ]

  def create
    spotify_id = params[ :spotify_id ]
    current_user.like( spotify_id )
    redirect_to band_url( spotify_id )
  end

  def destroy
    band_like = current_user.band_likes.find( params[ :id ] )
    band_like.destroy!
    redirect_to band_url( band_like.spotify_id )
  end

end
