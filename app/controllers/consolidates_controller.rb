class ConsolidatesController < ApplicationController
	before_action :require_user
	before_action :require_department_head
	def index
		sleep 1
		if current_user.designation.name == "Group Head"
			@consolidates = Consolidate.joins(user: [{department: :group}]).where("groups.id" => current_user.department.group.id).order("created_at DESC").paginate(page: params[:page], per_page: 5)
		elsif current_user.designation.name == "Department Head" && current_user.department.name == "Information and Communication Technology"
			@consolidates = Consolidate.joins(:category).where("categories.name" => "IT Equipment").order("created_at DESC").paginate(page: params[:page], per_page: 5)
		elsif current_user.designation.name == "Department Head" && current_user.department.name == "Property and Procurement"
			@consolidates = Consolidate.order("created_at DESC").paginate(page: params[:page], per_page: 5)
		elsif current_user.designation.name == "System Admin"
			@consolidates = Consolidate.all.order("created_at DESC").paginate(page: params[:page], per_page: 5)
		else
			@consolidates = Consolidate.where(:user_id => current_user.id).order("created_at DESC").paginate(page: params[:page], per_page: 5)
		end
	end

	def new
		@consolidate = Consolidate.new
		@request_ids = params[:request_ids]

		@grp = User.joins(:designation, [{department: :group}]).where(designations: { name: 'Group Head' }, groups: {name: current_user.department.group.name})
		@ppmd = User.joins(:designation, :department).where(designations: { name: 'Department Head' }, departments: { name: 'Property and Procurement' })
		@itd = User.joins(:designation, :department).where(designations: { name: 'Department Head' }, departments: { name: 'IT Department' })

		@requests = Request.find(@request_ids)
		@request_lines = RequestLine.where(:request_id => @request_ids)
		
		@requests.each do |r|
			@category_id = r.category_id
			@category = r.category.name
		end
		# raise params.inspect
	end

	def create
		@consolidate = Consolidate.new(consolidate_params)

		@grp = User.joins(:designation, [{department: :group}]).where(designations: { name: 'Group Head' }, groups: {name: current_user.department.group.name})
		@ppmd = User.joins(:designation, :department).where(designations: { name: 'Department Head' }, departments: { name: 'Property and Procurement' })
		@itd = User.joins(:designation, :department).where(designations: { name: 'Department Head' }, departments: { name: 'IT Department' })
		
		i = 0
		arr = Array.new(params[:consolidate][:consolidate_lines_attributes].length)
		while i < params[:consolidate][:consolidate_lines_attributes].length do 
			arr[i] = params[:consolidate][:consolidate_lines_attributes]["#{i}"][:request_id]
			i +=1
		end

		@requests = Request.find(arr)
		@request_lines = RequestLine.where(:request_id => arr)
			
		@requests.each do |r|
			@category_id = r.category_id
			@category = r.category.name
		end

		# raise params.inspect

		if @consolidate.save
			@requests.each do |req|
				params = ActionController::Parameters.new({
	                request: {
	                  status: "Consolidated"
	                }
	              })
	            permitted = params.require(:request).permit(:status)
	            req.update(permitted)
			end
			params = ActionController::Parameters.new({
	            consolidate: {
	                ConsNum: "RIS00000#{@consolidate.id}"
	            }
	        })
	        asd = params.require(:consolidate).permit(:ConsNum)
	        @consolidate.update(asd)
		
			flash[:success] = "Requests has successfully Consolidated"
			redirect_to consolidates_path
		else
			render 'new'
		end
	end

	def edit
		@time = Time.now 
		@consolidate = Consolidate.find(params[:id])
		@ppmd = User.joins(:designation, :department).where(designations: { name: 'Department Head' }, departments: { name: 'Property and Procurement' })
		@itd = User.joins(:designation, :department).where(designations: { name: 'Department Head' }, departments: { name: 'IT Department' })
	end

	def update
		time = Time.now 
		@action = params[:commit]
    	cons_ids = params[:cons_ids]
		@app = params[:approve]
		@disapp = params[:disapprove]
		@receive = params[:receive]
		@reject = params[:reject]
		@po = params[:po]
		@id = params[:id]
		# raise params.inspect
		if @action == "Approve" || @app != nil
			if @app != nil
				@consolidate = Consolidate.find(params[:id])
				params = ActionController::Parameters.new({
			        consolidate: {
			        	group_head_approve: time.to_formatted_s(:db).to_s, 
			            status: "Approved"
			        }
	                })
		        permitted = params.require(:consolidate).permit(:group_head_approve, :status)
		        if @consolidate.update(permitted)
		        	flash[:success] = "Requests has successfully Approved"
					redirect_to consolidates_path
		        else
		        	render 'index'
		        end
			else
				@x = 0
				arr = cons_ids.tr('', '').split(',').map(&:to_i)
				@status = Array.new(arr.length)
		        @categ = Array.new(arr.length)
	 
		        while @x < arr.length
		          @request = Consolidate.find(arr[@x])
		          @categ[@x] = @request.category.name
		          @status[@x] = @request.status
		          @x +=1
		        end
				
				# raise params.inspect
		        if @categ.uniq.length > 1
		        	if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Received") || 
		        			@status.include?("Rejected") || @status.include?("Purchase Ordered")
			          flash[:danger] = "Unable to approve request/s. Please select Consolidated Request/s"
			          redirect_to consolidates_path
			        else
		        		i = 0;
			        	while i < @x
				            @request = Consolidate.find(arr[i])
				            params = ActionController::Parameters.new({
				                consolidate: {
				        			group_head_approve: time.to_formatted_s(:db), 
				                  	status: "Approved"
				                }
				              })
				            permitted = params.require(:consolidate).permit(:group_head_approve, :status)
				            # raise params.inspect
				            @request.update(permitted)
				            i +=1
				        end
					flash[:success] = "Requests has successfully Approved"
					redirect_to consolidates_path
				    end
		        elsif @categ.uniq.length == 1
		        	# raise params.inspect
		        	if @categ[0] == "IT Equipment"
		        		if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Received") || 
		        				@status.include?("Rejected") || @status.include?("Purchase Ordered") || @status.include?("Pending")
				          flash[:danger] = "Unable to approve request/s. Please select Inspected Consolidated Request/s"
				          redirect_to consolidates_path
				        else
		        			i = 0;
				        	while i < @x
					            @request = Consolidate.find(arr[i])
					            params = ActionController::Parameters.new({
					                consolidate: {
					        			group_head_approve: time.to_formatted_s(:db), 
					                  	status: "Approved"
					                }
					              })
					            permitted = params.require(:consolidate).permit(:group_head_approve, :status)
					            # raise params.inspect
					            @request.update(permitted)
					            i +=1
					        end
						flash[:success] = "Requests has successfully Approved"
						redirect_to consolidates_path
					    end
		        	elsif @categ[0] == "Other Equipment"
		        		if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Received") || 
		        				@status.include?("Rejected") || @status.include?("Purchase Ordered") || @status.include?("Inspected")
				          flash[:danger] = "Unable to approve request/s. Please select Pending Consolidated Request/s"
				          redirect_to consolidates_path
				        else
		        			i = 0;
				        	while i < @x
					            @request = Consolidate.find(arr[i])
					            params = ActionController::Parameters.new({
					                consolidate: {
					        			group_head_approve: time.to_formatted_s(:db), 
					                  	status: "Approved"
					                }
					              })
					            permitted = params.require(:consolidate).permit(:group_head_approve, :status)
					            # raise params.inspect
					            @request.update(permitted)
					            i +=1
					        end
						flash[:success] = "Requests has successfully Approved"
						redirect_to consolidates_path
					    end
		        	end
		        elsif @categ.uniq.length == 0
		        	flash[:danger] = "Please select consolidated request/s to approve"
				    redirect_to consolidates_path
		        end
			end
		elsif @action == "Disapprove" || @disapp != nil
			if @disapp != nil
				@consolidate = Consolidate.find(params[:id])
				params = ActionController::Parameters.new({
			        consolidate: {
			        	group_head_approve: time.to_formatted_s(:db), 
			            status: "Dispproved"
			        }
	                })
		        permitted = params.require(:consolidate).permit(:group_head_approve, :status)
		        if @request.update(permitted)
		        	flash[:success] = "Requests has successfully Dispproved"
					redirect_to consolidates_path
		        else
		        	render 'index'
		        end
			else
				@x = 0
				arr = cons_ids.tr('', '').split(',').map(&:to_i)
				@status = Array.new(arr.length)
		        @categ = Array.new(arr.length)
	 
		        while @x < arr.length
		          @request = Consolidate.find(arr[@x])
		          @categ[@x] = @request.category_id
		          @status[@x] = @request.status
		          @x +=1
		        end

		        if @categ.uniq.length > 1
		        	if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Received") || 
		        			@status.include?("Rejected") || @status.include?("Purchase Ordered") || @status.include?("Pending")
				          flash[:danger] = "Unable to disapprove request/s. Please select Inspected Consolidated Request/s"
				          redirect_to consolidates_path
				    else
		        		i = 0;
				    	while i < @x
				            @request = Consolidate.find(arr[i])
				            params = ActionController::Parameters.new({
					            consolidate: {
					       			group_head_approve: time.to_formatted_s(:db), 
						          	status: "Dispproved"
					            }
				            })
					        permitted = params.require(:consolidate).permit(:group_head_approve, :status)
					        @request.update(permitted)
				            i +=1
					        end
						flash[:success] = "Requests has successfully Dispproved"
						redirect_to consolidates_path
					    end
		        elsif @categ.uniq.length == 1
		        	if @categ.uniq == "IT Equipment"
			        	if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Received") || 
			        			@status.include?("Rejected") || @status.include?("Purchase Ordered") || @status.include?("Inspected")
					        flash[:danger] = "Unable to approve request/s. Please select Inspected Consolidated Request/s"
					        redirect_to consolidates_path
					    else
			        		i = 0;
					    	while i < @x
						        @request = Consolidate.find(arr[i])
						        params = ActionController::Parameters.new({
							        consolidate: {
						       			group_head_approve: time.to_formatted_s(:db), 
							          	status: "Dispproved"
						            }
					            })
						        permitted = params.require(:consolidate).permit(:group_head_approve, :status)
						        @request.update(permitted)
						        i +=1
						    end
						flash[:success] = "Requests has successfully Dispproved"
						redirect_to consolidates_path
					    end
		        	elsif @categ.uniq == "Other Equipment"
		        		if @status.include?("Approved") || @status.include?("Dispproved") || @status.include?("Received") || 
			        			@status.include?("Rejected") || @status.include?("Purchase Ordered")
					        flash[:danger] = "Unable to approve request/s. Please select Pending Consolidated Request/s"
					        redirect_to consolidates_path
					    else
			        		i = 0;
					    	while i < @x
						        @request = Consolidate.find(arr[i])
						        params = ActionController::Parameters.new({
							        consolidate: {
						       			group_head_approve: time.to_formatted_s(:db), 
							          	status: "Dispproved"
						            }
					            })
						        permitted = params.require(:consolidate).permit(:group_head_approve, :status)
						        @request.update(permitted)
						        i +=1
						    end
						flash[:success] = "Requests has successfully Dispproved"
						redirect_to consolidates_path
					    end
		        	end
		        elsif @categ.uniq.length == 0
		        	flash[:danger] = "Please select consolidated request/s to disapprove"
		          	redirect_to consolidates_path
		        end
			end
		elsif @action == "Receive" || @receive != nil
			if @receive != nil
				@consolidate = Consolidate.find(params[:id])
				params = ActionController::Parameters.new({
			        consolidate: {
			        	ppmd_head_approve: time.to_formatted_s(:db), 
			            status: "Received"
			        }
	                })
		        permitted = params.require(:consolidate).permit(:ppmd_head_approve, :status)
		        if @request.update(permitted)
		        	flash[:success] = "Requests has successfully Received"
					redirect_to consolidates_path
		        else
		        	render 'index'
		        end
			else
				@x = 0
				arr = cons_ids.tr('', '').split(',').map(&:to_i)
				@status = Array.new(arr.length)
		        @categ = Array.new(arr.length)
	 
		        while @x < arr.length
		          @request = Consolidate.find(arr[@x])
		          @categ[@x] = @request.category_id
		          @status[@x] = @request.status
		          @x +=1
		        end

		        if @status.include?("Pending") || @status.include?("Dispproved") || @status.include?("Received") || 
		        	@status.include?("Rejected") || @status.include?("Purchase Ordered") || @status.include?("Inspected")
		          flash[:danger] = "Unable to Receive request/s. Please select Approved Consolidated Request/s"
		          redirect_to consolidates_path
		        elsif @categ.uniq.length == 0
		          flash[:danger] = "Please select consolidated request/s to Receive"
		          redirect_to consolidates_path
		        else
		        	i = 0;
		        	while i < @x
			            @request = Consolidate.find(arr[i])
			            params = ActionController::Parameters.new({
			                consolidate: {
			        			ppmd_head_approve: time.to_formatted_s(:db), 
			                  	status: "Received"
			                }
			              })
			            permitted = params.require(:consolidate).permit(:ppmd_head_approve, :status)
			            @request.update(permitted)
			            i +=1
			        end
				flash[:success] = "Requests has successfully Received"
				redirect_to consolidates_path
			    end
			end
		elsif @action == "Reject" || @reject != nil
			if @reject != nil
				@consolidate = Consolidate.find(params[:id])
				params = ActionController::Parameters.new({
			        consolidate: {
			        	ppmd_head_approve: time.to_formatted_s(:db), 
			            status: "Rejected"
			        }
	                })
		        permitted = params.require(:consolidate).permit(:ppmd_head_approve, :status)
		        if @request.update(permitted)
		        	flash[:success] = "Requests has successfully Rejected"
					redirect_to consolidates_path
		        else
		        	render 'index'
		        end
			else
				@x = 0
				arr = cons_ids.tr('', '').split(',').map(&:to_i)
				@status = Array.new(arr.length)
		        @categ = Array.new(arr.length)
	 
		        while @x < arr.length
		          @request = Consolidate.find(arr[@x])
		          @categ[@x] = @request.category_id
		          @status[@x] = @request.status
		          @x +=1
		        end

		        if @status.include?("Pending") || @status.include?("Dispproved") || @status.include?("Received") || 
		        	@status.include?("Rejected") || @status.include?("Purchase Ordered") || @status.include?("Inspected")
		          flash[:danger] = "Unable to reject request/s. Please select Approved Consolidated Request/s"
		          redirect_to consolidates_path
		        elsif @categ.uniq.length == 0
		          flash[:danger] = "Please select consolidated request/s to Reject"
		          redirect_to consolidates_path
		        else
		        	i = 0;
		        	while i < @x
			            @request = Consolidate.find(arr[i])
			            params = ActionController::Parameters.new({
			                consolidate: {
			        			ppmd_head_approve: time.to_formatted_s(:db), 
			                  	status: "Received"
			                }
			              })
			            permitted = params.require(:consolidate).permit(:ppmd_head_approve, :status)
			            @request.update(permitted)
			            i +=1
			        end
				flash[:success] = "Requests has successfully Rejected"
				redirect_to consolidates_path
			    end
			end
		elsif @action == "Make PO" || @po != nil
			if @po != nil
				@consolidate = Consolidate.find(params[:id])
				params = ActionController::Parameters.new({
			        consolidate: {
			        	ppmd_head_approve: time.to_formatted_s(:db), 
			            status: "Purchase Ordered"
			        }
	            })
		        permitted = params.require(:consolidate).permit(:ppmd_head_approve, :status)
		        if @request.update(permitted)
		        	flash[:success] = "Consolidated Requests has successfully Ordered"
					redirect_to consolidates_path
		        else
		        	render 'index'
		        end
			else
				@x = 0
				arr = cons_ids.tr('', '').split(',').map(&:to_i)
				@status = Array.new(arr.length)
		        @categ = Array.new(arr.length)
	 
		        while @x < arr.length
		          @request = Consolidate.find(arr[@x])
		          @categ[@x] = @request.category_id
		          @status[@x] = @request.status
		          @x +=1
		        end

		        if @status.include?("Pending") || @status.include?("Dispproved") || @status.include?("Approved") || 
		        	@status.include?("Rejected") || @status.include?("Purchase Requested") || @status.include?("Inspected")
			        flash[:danger] = "Unable to order request/s. Please select Received Consolidated Request/s."
			        redirect_to consolidates_path
		        elsif @categ.uniq.length > 1
		        	flash[:danger] = "Unable to order request/s. Please select 1 Request Type."
			        redirect_to consolidates_path
		        elsif @categ.uniq.length == 0
		          flash[:danger] = "Please select received consolidated request/s to Order."
		          redirect_to consolidates_path
		        else
		        	redirect_to new_order_path(:cons_ids => arr)
			    end
			end
		else
			@consolidate = Consolidate.find(@id)
			@specs = Array.new(consolidate_params[:consolidate_lines_attributes].length)
			i = 0
			while i < @specs.length do
				@specs[i] = consolidate_params[:consolidate_lines_attributes]["#{i}"][:specification]
				i +=1
			end
			if @specs.include?("")
				flash[:danger] = "Please don't leave a blank specification"
				redirect_to consolidates_path
			else
				params = ActionController::Parameters.new({
			        consolidate: {
			        	inspected_date: time.to_formatted_s(:db), 
			            status: "Inspected"
			        }
	                })
		        permitted = params.require(:consolidate).permit(:inspected_date, :status)
				@consolidate.update(permitted)
				x = 0
				while x < i do
					params = ActionController::Parameters.new({
				        consolidate_line: {
				            specification: @specs[x]
				        }
	                })
		        	asd = params.require(:consolidate_line).permit(:specification)
					@consolidate_line = ConsolidateLine.find(@consolidate.consolidate_lines.ids[x])
					@consolidate_line.update(asd)
					x +=1
				end
				flash[:success] = "Specification has been added!"
				redirect_to consolidates_path
			end
		end
	end

	def show
    	@consolidate = Consolidate.find(params[:id])
    	#@department_users = @department.users.paginate(page: params[:page], per_page: 5)
	end

	private
		def consolidate_params
	    	params.require(:consolidate).permit(:category_id, :user_id, :department_id, :officer_id, :received_by, :purpose, :inspected_by, :status, 
	       						consolidate_lines_attributes: [:consolidate_id, :request_id, :product_id, :type_id, :unit_id, :qty, :specification])
	  	end
end
