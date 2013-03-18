class SessionsController < ApplicationController
  
  def new
    logout_killing_session!
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    # Use this line for debugging in order to load specific user data
    # without knowing their password.
    #    user = User.find_by_username params[:username]
    # But DON'T DEPLOY IT WITH THIS!!!  HUGE SECURITY HOLE if you do.
    if user
      self.current_user = user
      redirect_to zap_cards_path
    else
      flash.now.alert = "Invalid username or password"
      render "new"
    end
  end

  def destroy
    logout_keeping_session!
    redirect_to root_url, :notice => "You've been logged out!"
  end
  
end
