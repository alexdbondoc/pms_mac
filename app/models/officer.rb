class Officer < ApplicationRecord
	belongs_to :department
	belongs_to :designation
	belongs_to :user
	has_many :requests, dependent: :destroy
end
