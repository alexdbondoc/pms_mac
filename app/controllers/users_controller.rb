class UsersController < ApplicationController
  before_action :require_user
  before_action :require_admin, except: [:index, :show]
	before_action :set_user, only: [:edit, :update, :show]
  def index
    @users = User.order("empname").paginate(page: params[:page], per_page: 5)
  end
  def new
		@user = User.new()
	end

	def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Employee information was saved successfully"
      redirect_to users_path
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Employee 's information was successfully updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    #@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  end

  private
  def user_params
    params.require(:user).permit(:empname, :email, :address, :contact_number, :department_id, :designation_id, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user and !urrent_user.designation.name == "System Admin"
      flash[:danger] = "You can only update your own account"
      redirect_to root_path
    end
  end

end