class UserBandRelationsController < ApplicationController
  before_action :logged_in_user

  def create
    @band = Band.find( params[ :band_id ] )
    current_user.like( @band )
    redirect_to @band
  end

  def destroy
    @band = UserBandRelation.find( params[ :id ] ).band
    current_user.unlike( @band )
    redirect_to @band
  end

end
