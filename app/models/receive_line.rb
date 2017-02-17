class ReceiveLine < ApplicationRecord
	belongs_to :type
	belongs_to :product
	belongs_to :unit
	belongs_to :receive, inverse_of: :receive_lines
end
