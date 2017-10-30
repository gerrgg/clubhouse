
class User < ApplicationRecord
  before_save :formalize_user

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                          format: { with: VALID_EMAIL_REGEX },
                          uniqueness: { case_sensitive: false }

  # presence of password and password_confirmation is validates through bcrypt
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  #returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def formalize_user
    self.email.downcase!
    self.name = self.name.titleize
  end



end
