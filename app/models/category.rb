class Category < ApplicationRecord
	has_many :types, dependent: :destroy
	has_many :requests, dependent: :destroy
	has_many :consolidates, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 3, maximum: 25}
end
