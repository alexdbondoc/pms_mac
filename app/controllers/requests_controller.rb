class RequestsController < ApplicationController
  before_action :require_user
	#before_action :require_admin, except: [:index, :show]
	def index
	    @requests = Request.order("date_created DESC").paginate(page: params[:page], per_page: 5)
	end
  
	def new
	  @request = Request.new
	end
  
  def create
    @request = Request.new(request_params)
      
    if request_params[:request_lines_attributes] == nil
      @var = false
    else
      @var = true
    end

    # raise request_params.inspect

    if @var == true
      if @request.save
        flash[:success] = "Request was created successfully."
        redirect_to requests_path
      else
        render 'new'
      end
    else
      if @request.save
        for x in 0..4
          if params[:request][:request_lines_attributes]["#{x}"] != ""
            @type_id = params[:request][:request_lines_attributes]["#{x}"][:type_id]
            @product_id = params[:request][:request_lines_attributes]["#{x}"][:product_id]
            @qty = params[:request][:request_lines_attributes]["#{x}"][:qty]
            @unit_id = params[:request][:request_lines_attributes]["#{x}"][:unit_id]
            params = ActionController::Parameters.new({
              request_line: {
                request_id: @request.id,
                type_id: @type_id,
                product_id: @product_id,
                qty: @qty,
                unit_id: @unit_id
              }
            })
            permitted = params.require(:request_line).permit(:request_id, :type_id, :product_id, :qty, :unit_id)
            @request_line = RequestLine.new(permitted)
            @request_line.save
          end
        end
        flash[:success] = "Request was created successfully."
        redirect_to requests_path
      else
        render 'new'
      end
    end
  end
  
	def edit
  	@request = Request.find(params[:id])
	end
  
  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      @x = 0
      @y = @request.request_lines.count;
      while @x < @y do
        if params[:request][:request_lines_attributes]["#{@x}"] != ""
          @type_id = params[:request][:request_lines_attributes]["#{@x}"][:type_id]
          @product_id = params[:request][:request_lines_attributes]["#{@x}"][:product_id]
          @qty = params[:request][:request_lines_attributes]["#{@x}"][:qty]
          @unit_id = params[:request][:request_lines_attributes]["#{@x}"][:unit_id]
          params = ActionController::Parameters.new({
            request_line: {
              request_id: @request.id,
              type_id: @type_id,
              product_id: @product_id,
              qty: @qty,
              unit_id: @unit_id
            }
          })
          permitted = params.require(:request_line).permit(:request_id, :type_id, :product_id, :qty, :unit_id)
          @request_line = @request.request_lines.update(permitted)
          @x +=1
        end
      end
      flash[:success] = "Request was created successfully."
      redirect_to requests_path
    else
      render 'new'
    end
    
  	# @request = Request.find(params[:id])
   #    if current_user == @request.user
   #        if @request.update(request_params)
   #        flash[:success] = "Request was successfully updated"
   #        redirect_to requests_path
   #      else
   #        render 'edit'
   #      end
   #    elsif current_user.id == @request.officer.user_id
   #      if params[:approve] != nil
   #        @request.status = "Approved"
   #        @status = "Approved"
   #      elsif params[:consolidate] != nil
   #        @request.status = "Consolidated"
   #        @status = "Consolidated"
   #      elsif params[:disapprove] != nil
   #        @request.status = "Disapproved"
   #        @status = "Disapproved"
   #      end 
   #      params = ActionController::Parameters.new({
   #        request: {
   #          category_id: @request.category_id,
   #          user_id:  @request.user_id,
   #          officer_id: @request.officer_id,
   #          department_id: @request.department_id,
   #          reason: @request.reason,
   #          status: @request.status
   #        }
   #      })
   #      permitted = params.require(:request).permit(:category_id, :user_id, :officer_id, :department_id, :reason, :status)
   #      if @request.update(permitted)
   #        flash[:success] = "Request was successfully #{@status}"
   #        redirect_to requests_path
   #      else
   #        render 'index'
   #      end
   #    end
	end

  def show
    @request = Request.find(params[:id])
    	#@department_users = @department.users.paginate(page: params[:page], per_page: 5)
	end

	def destroy
    @request = Request.find(params[:id])
	  @request.destroy
    flash[:danger] = "Request was successfully deleted"
    redirect_to requests_path
	end

	private
  	def request_params
    	params.require(:request).permit(:category_id, :user_id, :officer_id, :date_created, :reason, :status, :department_id,
       request_lines_attributes: [:request_id, :product_id, :type_id, :unit_id, :qty].reject{ |k,v| v.blank? })
  	end
    
    def require_same_user
      if current_user != @request.user and !current_desig.name == "System Admin"
        flash[:danger] = "You can only edit or delete your own requests"
        redirect_to root_path
      end
    end  
end
