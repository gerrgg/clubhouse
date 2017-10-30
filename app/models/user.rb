
class User < ApplicationRecord
  before_save :email_downcase

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                          format: { with: VALID_EMAIL_REGEX },
                          uniqueness: { case_sensitive: false }

  # presence of password and password_confirmation is validates through bcrypt
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  private

  def email_downcase
    self.email.downcase!
  end

end
