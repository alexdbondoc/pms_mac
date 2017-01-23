class OfficersController < ApplicationController
  before_action :require_user
	before_action :require_admin, except: [:index, :show]
	def index
	    @officers = Officer.paginate(page: params[:page], per_page: 5)
	end
  
	def new
	    @officer = Officer.new
	end
  
  	def create
    @officer = Officer.new(officer_params)
	    if @officer.save
	      flash[:success] = "Officer was assined successfully"
	      redirect_to officers_path
	    else
	      render 'new'
	    end
  	end
  
  	def edit
    	@officer = Officer.find(params[:id])
  	end
  
  	def update
    	@officer = Officer.find(params[:id])
    	if @officer.update(officer_params)
    		flash[:success] = "Officer was successfully updated"
    		redirect_to officer_path(@officer)
    	else
    		render 'edit'
    	end
  	end
  
  	def show
    	@officer = Officer.find(params[:id])
    	#@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  	end
  	private
  	def officer_params
    	params.require(:officer).permit(:user_id, :department_id, :designation_id)
  	end
  
  	def require_admin
    	if !logged_in? || (logged_in? and !current_desig.name == "System Admin")
      		flash[:danger] = "Only admins can perform that action"
      		redirect_to officers_path
  		end
  	end
end
