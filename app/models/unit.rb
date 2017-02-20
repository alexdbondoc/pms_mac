class Unit < ApplicationRecord
	has_many :request_lines, dependent: :destroy
	has_many :consolidate_lines, dependent: :destroy
	has_many :order_lines, dependent: :destroy
	has_many :receive_lines, dependent: :destroy
	has_many :inventories, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 3, maximum: 25}
end
