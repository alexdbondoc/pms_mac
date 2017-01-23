class User < ApplicationRecord
	belongs_to :department
	belongs_to :designation
	has_many :officers, dependent: :destroy
	has_many :requests, dependent: :destroy

	before_save{ self.email = email.downcase }
	validates :empname, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 10, maximum: 100}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 105 },
				uniqueness: { case_sensitive: false }, 
				format: { with: VALID_EMAIL_REGEX }
	validates :address, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 25, maximum: 150}
	validates :contact_number, presence: true, 
				uniqueness: { case_sensitive: false }, 
				length: { minimum: 11, maximum: 11}
	has_secure_password
end