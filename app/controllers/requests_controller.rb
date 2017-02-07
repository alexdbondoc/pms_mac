class RequestsController < ApplicationController
  # before_action :require_same_user
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
    @action = params[:commit]
    request_ids = params[:request_ids]
    @act = false
    @id = params[:id]
    @lines = params[:request][:request_lines_attributes]

    # arr = eval(request_ids)
    # arr = request_ids[1..-2].split(',').collect! {|n| n.to_i}
    if current_user.designation.name == "Department Head"
      if @action == "Approve"
        @x = 0
        arr = request_ids.tr('', '').split(',').map(&:to_i)
        @status = Array.new(arr.length)
        @categ = Array.new(arr.length)

        while @x < arr.length
          @request = Request.find(arr[@x])
          @categ[@x] = @request.category_id
          @status[@x] = @request.status
          @x +=1
        end

        i = 0;
        if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Consolidated")
          flash[:danger] = "Unable to approve request/s. Please select Pending Request/s"
          redirect_to requests_path
        elsif @categ.uniq.length == 0
          flash[:danger] = "Please select request/s to be approved"
          redirect_to requests_path
        else
          while i < @x
            @request = Request.find(arr[i])
            params = ActionController::Parameters.new({
                request: {
                  status: "Approved"
                }
              })
            permitted = params.require(:request).permit(:status)
            @request.update(permitted)
            i +=1
          end
        # raise request_params.inspect
        flash[:success] = "Request was approved successfully."
        redirect_to requests_path
        end
      elsif @action == "Disapprove"
        @x = 0
        arr = request_ids.tr('', '').split(',').map(&:to_i)
        @status = Array.new(arr.length)
        @categ = Array.new(arr.length)

        while @x < arr.length
          @request = Request.find(arr[@x])
          @categ[@x] = @request.category_id
          @status[@x] = @request.status
          @x +=1
        end
        
        i = 0;
        if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Consolidated")
          flash[:danger] = "Unable to Disapprove request/s. Please select Pending Request/s"
          redirect_to requests_path
        elsif @categ.uniq.length == 0
          flash[:danger] = "Please select request/s to be disapproved"
          redirect_to requests_path
        else
          while i < @x
            @request = Request.find(arr[i])
            params = ActionController::Parameters.new({
                request: {
                  status: "Disapproved"
                }
              })
            permitted = params.require(:request).permit(:status)
            @request.update(permitted)
            i +=1
          end
          # raise request_params.inspect
          flash[:success] = "Request was Disapproved successfully."
          redirect_to requests_path
        end
      else
        @x = 0
        arr = request_ids.tr('', '').split(',').map(&:to_i)
        @status = Array.new(arr.length)
        @categ = Array.new(arr.length)
        @act = false

        while @x < arr.length
          @request = Request.find(arr[@x])
          @categ[@x] = @request.category_id
          @status[@x] = @request.status
          @x +=1
        end

        # raise request_params.inspect
        i = 0;
        if @status.include?("Dispproved") || @status.include?("Pending") || @categ.uniq.length > 1 
          flash[:danger] = "Unable to Consolidate request/s. Please select Approved Request/s"
          redirect_to requests_path
        elsif @categ.uniq.length == 0
          flash[:danger] = "Please select request/s to be Consolidated"
          redirect_to requests_path
        else
          # raise request_params.inspect
          redirect_to new_consolidate_path(:request_ids => arr)
        end
      end
    else
      @request = Request.find(@id)
      if @request.update(request_params)
        @x = 0
        @y = @request.request_lines.count;
        while @x < @y do
          if @lines != ""
            params = ActionController::Parameters.new({
              request_line: {
                request_id: @id,
                type_id: @lines["#{@x}"][:type_id],
                product_id: @lines["#{@x}"][:product_id],
                qty: @lines["#{@x}"][:qty],
                unit_id: @lines["#{@x}"][:unit_id]
              }
            })
            permitted = params.require(:request_line).permit(:request_id, :type_id, :product_id, :qty, :unit_id)
            @request_lines = @request.request_lines.update(permitted)
            @x +=1
          end
        end
        # raise params.inspect
        flash[:success] = "Request was updated successfully."
        redirect_to requests_path
      else
        render 'new'
      end
    end
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
