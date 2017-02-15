class OrderLine < ApplicationRecord
	belongs_to :product
	belongs_to :order, inverse_of: :order_lines
	belongs_to :consolidate
	belongs_to :type
	belongs_to :unit
	validates :unit_price, presence: true, length: { minimum: 2, maximum: 9}, :numericality => { :greater_than => 0 }	
end
