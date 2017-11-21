
class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :formalize_user
  before_create :create_activation_digest


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

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    self.update_attributes(activated: true,
                           activated_at: Time.now)
  end

  def update_activation_digest
    self.activation_token = User.new_token
    self.update_attribute(:activation_digest, User.digest(activation_token))
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def formalize_user
    self.email.downcase!
    self.name = self.name.titleize
  end

end
