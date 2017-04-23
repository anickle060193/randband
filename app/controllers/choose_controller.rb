class ChooseController < ApplicationController
  before_action :logged_in_user

  def choose
    band_ids = BandGenre.joins( :genre ).where( genres: { name: params[ :genres ] }, band: current_user.liked_bands ).distinct.pluck( :band_id )
    @band = Band.find_by( id: band_ids.sample )
    if @band.blank?
      flash[ :warning ] = "No band found matching genres. Try again?"
      redirect_to chooser_path
    end
    respond_to( :html, :js )
  end

  def chooser
    @genres = BandGenre.joins( :genre ).where( band: current_user.liked_bands ).distinct.pluck( :name ).sort
  end

end
