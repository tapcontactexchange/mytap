class UsersController < ApplicationController
  
  def reset_password
    if !params[:email].blank?
      User.reset_password(params[:email])
      flash[:notice] = "You should receive a password reset email shortly!"
      redirect_to root_url
    else
      flash[:error] = "Please enter your Tap email address"
      render :action => 'forgot_password'
    end    
  end
end
