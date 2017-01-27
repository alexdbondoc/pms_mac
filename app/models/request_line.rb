class RequestLine < ApplicationRecord
	belongs_to :product
	belongs_to :request
	belongs_to :type
	belongs_to :unit
	belongs_to :product
	belongs_to :type
	belongs_to :unit
end
