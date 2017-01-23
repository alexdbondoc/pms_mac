class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :current_desig

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_desig
    @current_desig ||= Designation.find(current_user.designation_id)
  end

  #def current_officer
    #@off = Arel::Table.new(:officers)
    #current_officer ||= @off.where(@off[:department_id].eq(current_user.department_id)).project(Arel.sql('*'))
    #current_officer.to_sql
    #@officer_data = current_officer
    #current_officer = Officer.select("*").where(:department_id => current_user.department_id)
  #end

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
