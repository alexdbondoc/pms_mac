class Supplier < ApplicationRecord
	has_many :orders, dependent: :destroy
	validates :name, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 10, maximum: 100}
	validates :address, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 25, maximum: 150}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 105 },
				uniqueness: { case_sensitive: false }, 
				format: { with: VALID_EMAIL_REGEX }
	validates :tel, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 7, maximum: 8}
	validates :tin, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 9, maximum: 11}
	validates :fax, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 15, maximum: 20}
	validates :representative, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 10, maximum: 100}
end
