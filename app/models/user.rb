class User < ActiveRecord::Base
  # neutralize user submitted email cases
  before_save { self.email = email.downcase }

  # validate name presence and max length
  validates :name, presence: true, length: { maximum: 50 }

  # validate email presence, max length, format, and uniqueness
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
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
end
