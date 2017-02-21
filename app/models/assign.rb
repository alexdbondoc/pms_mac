class Assign < ApplicationRecord
	has_many :assign_lines, inverse_of: :assign, dependent: :destroy
	accepts_nested_attributes_for :assign_lines
	belongs_to :user
	validates :remarks, presence: true, length: { minimum: 5, maximum: 150}
end
