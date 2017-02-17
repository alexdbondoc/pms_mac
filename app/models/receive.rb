class Receive < ApplicationRecord
	belongs_to :user
	belongs_to :order
	has_many :receive_lines, inverse_of: :receive, dependent: :destroy
	accepts_nested_attributes_for :receive_lines
	validates :dr_num, presence: true
	validates :dr_date, presence: true
	validates :invoice_num, presence: true
	validates :invoice_date, presence: true
	validates :delivery_type, presence: true
end
