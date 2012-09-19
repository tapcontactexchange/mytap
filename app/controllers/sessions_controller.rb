class SessionsController < ApplicationController
  
  def new
    logout_killing_session!
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      self.current_user = user
      redirect_to contacts_path #zap_cards_path
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
