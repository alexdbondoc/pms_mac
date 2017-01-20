class DesignationsController < ApplicationController
	before_action :require_admin, except: [:index, :show]
  def index
	    @designations = Designation.paginate(page: params[:page], per_page: 5)
	end
  
	  def new
	    @designation = Designation.new
	  end
  
  	def create
    @designation = Designation.new(designation_params)
    if @designation.save
      flash[:success] = "Designation was created successfully"
      redirect_to designations_path
    else
      render 'new'
    end
  end
  
  def edit
    @designation = Designation.find(params[:id])
  end
  
  def update
    @designation = Designation.find(params[:id])
    if @designation.update(designation_params)
      flash[:success] = "Designation name was successfully updated"
      redirect_to designation_path(@designation)
    else
      render 'edit'
    end
  end
  
  def show
    @designation = Designation.find(params[:id])
    #@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  end

  private
  def designation_params
    params.require(:designation).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_desig.name == "System Admin")
      flash[:danger] = "Only admins can perform that action"
      redirect_to designations_path
    end
  end

end