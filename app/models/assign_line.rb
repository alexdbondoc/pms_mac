class AssignLine < ApplicationRecord
	belongs_to :assign, inverse_of: :assign_lines
	belongs_to :inventory
	belongs_to :user
end
