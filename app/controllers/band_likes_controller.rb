class BandLikesController < ApplicationController
  before_action :logged_in_user, only: [ :create, :destroy ]

  def create
    band = Band.find_by( id: params[ :band_id ] )
    band ||= Band.find_by_provider( params[ :provider ], params[ :provider_id ] )
    current_user.like( band ) unless current_user.likes?( band )
    redirect_to band_link( band )
  end

  def destroy
    band_like = BandLike.find_by( id: params[ :id ] )
    if band_like.nil?
      redirect_to band_link( Band.find_by( id: params[ :band_id ] ) )
    else
      current_user.unlike( band_like.band )
      redirect_to band_link( band_like.band )
    end
  end

end
