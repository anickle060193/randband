class ChooseController < ApplicationController
  before_action :logged_in_user

  def choose
    band_ids_from_genres = current_user.liked_bands.joins( :genres ).where( genres: { name: params[ :genres ] } ).distinct.reorder( nil ).pluck( :id )
    band_ids_from_genre_groups = current_user.liked_bands.joins( :genre_groups ).where( genre_groups: { name: params[ :genre_groups ] } ).distinct.reorder( nil ).pluck( :id )
    band_ids = band_ids_from_genres | band_ids_from_genre_groups
    @band = Band.find_by( id: band_ids.sample )
    if @band.blank?
      flash[ :warning ] = "No band found matching genres. Try again?"
      redirect_to chooser_path
    end
    respond_to( :html, :js )
  end

  def chooser
    @genres = Genre.for_user( current_user ).order( :name ).pluck( :name )
    @genre_groups = current_user.genre_groups.order( :name ).pluck( :name )
  end

end
