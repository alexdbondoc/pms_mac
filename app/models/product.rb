class Product < ApplicationRecord
	belongs_to :type
	has_many :requests, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 3, maximum: 25}
end