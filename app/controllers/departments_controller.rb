class DepartmentsController < ApplicationController
  before_action :require_user
	before_action :require_admin, except: [:index, :show]
	def index
	    @departments = Department.order("name").paginate(page: params[:page], per_page: 5)
	end
  
	  def new
	    @department = Department.new
	  end
  
  	def create
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = "Department was created successfully"
      redirect_to departments_path
    else
      render 'new'
    end
  end
  
  def edit
    @department = Department.find(params[:id])
  end
  
  def update
    @department = Department.find(params[:id])
    if @department.update(department_params)
      flash[:success] = "Department name was successfully updated"
      redirect_to department_path(@department)
    else
      render 'edit'
    end
  end
  
  def show
    @department = Department.find(params[:id])
    #@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  end
  private
  def department_params
    params.require(:department).permit(:name, :group_id)
  end
  
  def require_admin
    if !logged_in? || (logged_in? and !current_desig.name == "System Admin")
      flash[:danger] = "Only admins can perform that action"
      redirect_to departments_path
  	end
  end
end