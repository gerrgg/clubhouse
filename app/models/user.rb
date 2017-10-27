class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true

  # presence of password and password_confirmation is validates through bcrypt
  validates :password, presence: true, length: { minimum: 8 }

  has_secure_password
end
