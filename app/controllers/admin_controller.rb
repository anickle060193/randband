class AdminController < ApplicationController
  before_action :admin_user
  before_action :store_location

  def home
  end

  def users
    @users = User.order_by_username.page( params[ :page ] ).per( 20 )
  end

  def bands
    @bands = Band.order_by_name.page( params[ :page ] ).per( 10 )
  end

  private

    def admin_user
      redirect_to( root_url ) unless admin?
    end

end
