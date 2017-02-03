class ConsolidateLine < ApplicationRecord
	belongs_to :product
	belongs_to :consolidate, inverse_of: :consolidate_lines
	belongs_to :type
	belongs_to :unit
	has_many :requests
end
