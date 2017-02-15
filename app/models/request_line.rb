class RequestLine < ApplicationRecord
	belongs_to :product
	belongs_to :request, inverse_of: :request_lines
	belongs_to :type
	belongs_to :unit
	validates :product_id, presence: true, 
				length: { maximum: 10 }
	validates :type_id, presence: true, 
				length: { maximum: 10 }
	validates :qty, presence: true, 
				length: { maximum: 1 }
	validates :unit_id, presence: true, 
				length: { maximum: 10 }
end
