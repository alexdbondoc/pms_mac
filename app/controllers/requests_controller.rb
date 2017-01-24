class RequestsController < ApplicationController
  before_action :require_user
	#before_action :require_admin, except: [:index, :show]
	def index
	    @requests = Request.paginate(page: params[:page], per_page: 5)
	end
  
	def new
	    @request = Request.new()
	end
  
  	def create
    @request = Request.new(request_params)
    @request.user_id = current_user.id
    @request.status = "Pending"
    @request.department_id = current_user.department_id
    @current_officer = Officer.select("*").where(:department_id => current_user.department_id) 
      @current_officer.each do |co| 
      	@officer = co.id
      end
      @request.officer_id = @officer

  		if @request.save
  		    flash[:success] = "Request was created successfully"
  		    redirect_to requests_path
  		else
  		    render 'new'
  		end
  	end
  
  	def edit
    	@request = Request.find(params[:id])
  	end
  
  	def update
    	@request = Request.find(params[:id])
      if current_user == @request.user
          if @request.update(request_params)
          flash[:success] = "Request was successfully updated"
          redirect_to requests_path
        else
          render 'edit'
        end
      elsif current_user.id == @request.officer.user_id
        if @request.status == "Pending"
          @request.status = "Approved"
        else
          @request.status = "Consolidated"
        end
        params = ActionController::Parameters.new({
          request: {
            category_id: @request.category_id,
            user_id:  @request.user_id,
            officer_id: @request.officer_id,
            department_id: @request.department_id,
            type_id: @request.type_id,
            product_id: @request.product_id,
            qty: @request.qty,
            unit_id: @request.unit_id,
            reason: @request.reason,
            status: @request.status
          }
        })
        permitted = params.require(:request).permit(:category_id, :user_id, :officer_id, :department_id, :type_id, :product_id, :qty, :unit_id, :reason, :status)
        if @request.update(permitted)
          flash[:success] = "Request was successfully approved"
          redirect_to requests_path
        else
          render 'index'
        end
      end
  	end
  
  	def show
    	@request = Request.find(params[:id])
    	#@department_users = @department.users.paginate(page: params[:page], per_page: 5)
  	end

  	def destroy
	    @request.destroy
	    flash[:danger] = "Request was successfully deleted"
	    redirect_to requests_path
  	end

  	private
  	def request_params
    	params.require(:request).permit(:category_id, :user_id, :officer_id, :department_id, :type_id, :product_id, :qty, :unit_id, :reason, :status)
  	end
  
    def require_same_user
      if current_user != @request.user and !current_desig.name == "System Admin"
        flash[:danger] = "You can only edit or delete your own requests"
        redirect_to root_path
      end
    end
  
end
