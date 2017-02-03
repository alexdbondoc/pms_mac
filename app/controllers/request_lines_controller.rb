class RequestLinesController < ApplicationController
	def create
		@request_line = RequestLine.new(request_line_params)
		@request_line.request_id = Request.last(:id)
		@request_line.save
	end

	def update
		if params[:approve] != nil
			raise params.inspect
			flash[:success] = "Request was updated successfully."
      		redirect_to requests_path
		end
	end

	private
	def request_line_params
		params.require(:request_line).permit(:product_ids, :request_ids, :type_ids, :unit_ids, :qtys)
	end
end
