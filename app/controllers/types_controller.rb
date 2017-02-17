class TypesController < ApplicationController
  before_action :require_user
	before_action :require_admin, except: [:index, :show]
  def index
	    @types = Type.order("name").paginate(page: params[:page], per_page: 5)
	end
  
	  def new
	    @type = Type.new
	  end
  
  	def create
    @type = Type.new(type_params)
    #@type.category = @category_id.to_i
    if @type.save
      flash[:success] = "Product type was created successfully"
      redirect_to types_path
    else
      render 'new'
    end
  end
  
  def edit
    @type = Type.find(params[:id])
  end
  
  def update
    @type = Type.find(params[:id])
    if @type.update(type_params)
      flash[:success] = "Product type name was successfully updated"
      redirect_to type_path(@type)
    else
      render 'edit'
    end
  end
  
  def show
    @type = Type.find(params[:id])
    #@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  end

  private
    def type_params
      params.require(:type).permit(:name, :category_id)
    end

end