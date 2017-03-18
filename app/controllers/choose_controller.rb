class ChooseController < ApplicationController
  before_action :logged_in_user, only: [ :index ]

  def index
    @band = current_user.bands.offset( rand( current_user.bands.length ) ).first
  end

end
