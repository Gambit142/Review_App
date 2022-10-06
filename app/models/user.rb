class User < ApplicationRecord
  has_secure_password
  validates :name, presence: {message: "Name can't be blank"}
  validates :email, presence: {message: "Email can't be blank"}, 
            uniqueness: {message: "This Email already exists"}
end
