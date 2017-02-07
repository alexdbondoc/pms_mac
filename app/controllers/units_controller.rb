class UnitsController < ApplicationController
  before_action :require_user
	before_action :require_admin, except: [:index, :show]
	def index
	    @units = Unit.order("name").paginate(page: params[:page], per_page: 5)
	end
  
	  def new
	    @unit = Unit.new
	  end
  
  	def create
    @unit = Unit.new(unit_params)
    if @unit.save
      flash[:success] = "Unit was created successfully"
      redirect_to units_path
    else
      render 'new'
    end
  end
  
  def edit
    @unit = Unit.find(params[:id])
  end
  
  def update
    @unit = Unit.find(params[:id])
    if @unit.update(unit_params)
      flash[:success] = "Unit name was successfully updated"
      redirect_to unit_path(@unit)
    else
      render 'edit'
    end
  end
  
  def show
    @unit = Unit.find(params[:id])
    #@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  end
  private
  def unit_params
    params.require(:unit).permit(:name)
  end
  
  def require_admin
    if !logged_in? || (logged_in? and !current_desig.name == "System Admin")
      flash[:danger] = "Only admins can perform that action"
      redirect_to departments_path
  	end
  end
end
