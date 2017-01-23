class Request < ApplicationRecord
	belongs_to :category
	belongs_to :department
	belongs_to :product
	belongs_to :officer
	belongs_to :product
	belongs_to :type
	belongs_to :unit
	belongs_to :user
	validates :qty, presence: true, 
				length: { minimum: 1, maximum: 2}	
	validates :reason, presence: true, 
				length: { minimum: 15, maximum: 50}	
end
