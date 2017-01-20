class Designation < ApplicationRecord
	has_many :users, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 8, maximum: 25}
end