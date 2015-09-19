class User < ActiveRecord::Base
  attr_accessor :remember_token
  # neutralize user submitted email cases
  before_save { email.downcase! }

  # validate name presence and max length
  validates :name, presence: true, length: { maximum: 50 }

  # validate email presence, max length, format, and uniqueness
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
              format: { with: VALID_EMAIL_REGEX }, 
              uniqueness: { case_sensitive: false }

  # add secure password machinery provided by Rails:
  # - the ability to save a securely hashed "password_digest" 
  #   attribute to the database (the model's db table must 
  #   contain a "password_digest" column)
  # - a pair of virtual attributes ("passwrod" and 
  #   "password_confirmation") including presence validation
  #   and match validation on object creation
  # - an "authenticate" method that returns the user when the
  #   password is correct, or "false" if otherwise
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user for logging out
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_token).is_password?(remember_token)
  end

  # ======== class methods
  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

end
