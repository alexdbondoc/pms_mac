class Order < ApplicationRecord
	belongs_to :user
	belongs_to :supplier
	has_many :order_lines, inverse_of: :order, dependent: :destroy
	accepts_nested_attributes_for :order_lines
	validates :supplier_id, presence: true
	validates :delivery_date, presence: true
end
