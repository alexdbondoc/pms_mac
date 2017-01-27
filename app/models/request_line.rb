class RequestLine < ApplicationRecord
	belongs_to :product
	belongs_to :request, inverse_of: :request_lines
	belongs_to :type
	belongs_to :unit
end
