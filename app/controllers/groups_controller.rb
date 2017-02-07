class GroupsController < ApplicationController
  before_action :require_user
  before_action :require_admin, except: [:index, :show]
	def index
	    @groups = Group.order("name").paginate(page: params[:page], per_page: 5)
	end
  
	  def new
	    @group = Group.new
	  end
  
  	def create
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = "Group was created successfully"
      redirect_to groups_path
    else
      render 'new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      flash[:success] = "Group name was successfully updated"
      redirect_to group_path(@group)
    else
      render 'edit'
    end
  end
  
  def show
    @group = Group.find(params[:id])
    #@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  end

  private
  def group_params
    params.require(:group).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_desig.name == "System Admin")
      flash[:danger] = "Only admins can perform that action"
      redirect_to groups_path
    end
  end
end
