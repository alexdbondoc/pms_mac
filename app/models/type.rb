class Type < ApplicationRecord
	belongs_to :category
	has_many :request_lines, dependent: :destroy
	has_many :products, dependent: :destroy
	has_many :consolidate_lines, dependent: :destroy
	has_many :order_lines, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 3, maximum: 25}
end