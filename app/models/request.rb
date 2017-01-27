class Request < ApplicationRecord
	belongs_to :category
	belongs_to :department
	belongs_to :officer
	belongs_to :user
	has_many :request_lines
	accepts_nested_attributes_for :request_lines,
    			:allow_destroy => true
	validates :reason, presence: true, length: { minimum: 15, maximum: 150}	
end
