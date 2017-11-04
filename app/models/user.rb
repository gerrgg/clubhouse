
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
    SecureRandom.urlsafe_base64
  end

  def remember
    #use self to create a token specific to *this* user
    self.remember_token = User.new_token
    #digest the token and store it into db for comparison
    # requires the attribute to be accessisble via attr_accessor
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token) #pass token from cookies
    return false if remember_digest.nil? #skip next line
    BCrypt::Password.new(remember_digest).is_password?(remember_token) #compare passed token and compare to digest
  end



  private

  def formalize_user
    self.email.downcase!
    self.name = self.name.titleize
  end



end
