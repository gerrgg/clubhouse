
class User < ApplicationRecord
  attr_accessor :remember_token
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
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    #create token
    SecureRandom.urlsafe_base64
  end

  def remember
    # first create a token
    self.remember_token = User.new_token
    # and we digest that token and store it in the db for comparison
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, :nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private

  def formalize_user
    self.email.downcase!
    self.name = self.name.titleize
  end




end
