class ApplicationController < ActionController::Base

  protect_from_forgery
  
  helper_method :current_user, :signed_in?
  
  protected
  
  def current_user
    @current_user ||= session[:user]
  end
  
  def signed_in?
    !!current_user
  end
  
end
