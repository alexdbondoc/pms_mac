class OrderLine < ApplicationRecord
	belongs_to :product
	belongs_to :order, inverse_of: :order_lines
	belongs_to :consolidate
	belongs_to :type
	belongs_to :unit
end
