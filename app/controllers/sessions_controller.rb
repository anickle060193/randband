class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by( username: params[ :session ][ :username ] )
    if user && user.authenticate( params[ :session ][ :password ] )
      log_in user
      if params[ :session ][ :remember_me ] == '1'
        remember( user )
      else
        forget( user )
      end
      redirect_back_or root_url
    else
      flash.now[ :danger ] = 'Invalid username/password combination'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
