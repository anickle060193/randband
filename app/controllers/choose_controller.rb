class ChooseController < ApplicationController
  before_action :logged_in_user, only: [ :index ]

  def index
    band_like = current_user.band_likes.offset( rand( current_user.band_likes.length ) ).first
    @band = RSpotify::Artist.find( band_like.spotify_id )
  end

end
