class Type < ApplicationRecord
	belongs_to :category
	has_many :products, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 3, maximum: 25}
end