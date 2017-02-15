class Consolidate < ApplicationRecord
	belongs_to :category
	belongs_to :department
	belongs_to :officer
	belongs_to :user
	has_many :consolidate_lines, inverse_of: :consolidate, dependent: :destroy
	has_many :order_lines, dependent: :destroy
	accepts_nested_attributes_for :consolidate_lines
	validates :purpose, presence: true, length: { minimum: 15, maximum: 150}
end
