class ProductsController < ApplicationController
  before_action :require_user
	before_action :require_admin, except: [:index, :show]
  def index
	    @products = Product.order("name").paginate(page: params[:page], per_page: 5)
	end
  
	  def new
	    @product = Product.new
	  end
  
  	def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product was created successfully"
      redirect_to products_path
    else
      render 'new'
    end
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = "Product name was successfully updated"
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end
  
  def show
    @product = Product.find(params[:id])
    #@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  end

  private
  def product_params
    params.require(:product).permit(:name, :type_id)
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_desig.name == "System Admin")
      flash[:danger] = "Only admins can perform that action"
      redirect_to products_path
    end
  end

end