class Department < ApplicationRecord
	belongs_to :group
	has_many :users, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 8, maximum: 50}
end