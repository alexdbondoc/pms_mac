class ConsolidatesController < ApplicationController
	# before_action :require_same_user
	before_action :require_user
	def index
		@consolidates = Consolidate.order("date_created DESC").paginate(page: params[:page], per_page: 5)
	end

	def new
		@consolidate = Consolidate.new
		@request_ids = params[:request_id]
		@request_ids.each do |req|
			@requests = Request.find(@request_ids)
			@request_lines = RequestLine.where(:request_id => @request_ids)
		end

		@officer = Officer.joins(:designation, department: :department)
		x = 0
		@categ = Array.new(@requests.length)
		while x < @requests.length do
			@categ[x] = @requests[x].category
			x +=1
		end
		@category = @categ.uniq
		raise params.inspect
	end

	def create
		@consolidate = Consolidate.new
	end

	def edit
  		@consolidate = Consolidate.find(params[:id])
	end

	def update
		@consolidate = Consolidate.find(params[:id])
	end

	def destroy

	end

	def show
    	@consolidate = Consolidate.find(params[:id])
    	#@department_users = @department.users.paginate(page: params[:page], per_page: 5)
	end

	def destroy
	    @consolidate = Consolidate.find(params[:id])
		@consolidate.destroy
	    flash[:danger] = "Request was successfully deleted"
	    redirect_to requests_path
	end
	private
		def consolidate_params
	    	params.require(:consolidate).permit(:category_id, :user_id, :department_id, :officer_id, :received_by, :purpose,
	       consolidate_lines_attributes: [:consolidate_id, :request_id, :product_id, :type_id, :unit_id, :qty].reject{ |k,v| v.blank? })
	  	end
	    
	    def require_same_user
	      if current_user != @request.user and !current_desig.name == "System Admin"
	        flash[:danger] = "You can only edit or delete your own requests"
	        redirect_to root_path
	      end
	    end  
end
