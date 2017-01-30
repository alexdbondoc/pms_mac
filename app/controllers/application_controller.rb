class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :current_desig, :consolidate_action, :approve_action

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_desig
    @current_desig ||= Designation.find(current_user.designation_id)
  end

  def consolidate_action
    @consolidate_action
  end

  def approve_action
    @approve_action
  end

  def logged_in?
    !!current_user
  end

  def require_user
  	if !logged_in?
  		flash[:danger] = "You must be logged in to perform that action"
  		redirect_to root_path
  	end
  end

end
