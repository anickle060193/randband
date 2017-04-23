class BandLikesController < ApplicationController
  before_action :logged_in_user, only: [ :create, :destroy ]

  def create
    BandLike.transaction do
      @band = Band.find_by( id: params[ :band_id ] )
      @band ||= Band.find_or_create_by_provider( params[ :provider ], params[ :provider_id ] )

      current_user.like( @band ) unless current_user.likes?( @band )

      respond_to do |format|
        format.html { redirect_to band_link( @band ) }
        format.js
      end
    end
  end

  def destroy
    @band = BandLike.find_by( id: params[ :id ] )&.band
    @band ||= Band.find_by( id: params[ :band_id ] )
    current_user.unlike( @band ) if current_user.likes?( @band )

    respond_to do |format|
      format.html { redirect_to band_link( @band ) }
      format.js
    end
  end

end
