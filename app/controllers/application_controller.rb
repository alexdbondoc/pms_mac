class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
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

  def require_property
    if current_user.department.name != "Property and Procurement"
      flash[:danger] = "Only employee's that belong to Property and Procurement Department can access this. "
      redirect_to user_path(current_user)
    end
  end

  def require_department_head
    if current_user.designation.name != "Department Head" && current_user.designation.name != "Group Head"
      flash[:danger] = "You don't have the previlages to access this."
      redirect_to user_path(current_user)
    end
  end

  def require_admin
    if current_user.designation.name != "System Admin"
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to user_path(current_user)
    end
  end

end
