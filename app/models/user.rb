class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

  # user follows other users
  # user is the foreign_key, 
  # is in "follower" column
  # the other users are in the "followed" column
  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships,
                       source: :followed

  # user has followers
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships,
                       source: :follower
                                  
  attr_accessor :remember_token, :activation_token, :reset_token
  # neutralize user submitted email cases
  before_save :downcase_email
  before_create :create_activation_digest

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
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    # encrypt remember_token and save it in :remember_digest field in db
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user for logging out 
  # by setting its :remember_digest attribute in database to nil
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    # decrypt current remember_digest attribute and compare it to remember_token
    BCrypt::Password.new(digest).is_password?(token)
  end

  # account activation
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # reset password
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  def feed
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    following_ids_SQL_string = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids_SQL_string}) OR user_id = :user_id", user_id: id)
  end

  # Follows a user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

  # ========= private methods

  private
    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
      # activation_digest will be automatically saved to db since there is a db column for it
    end

  # ======== class methods
  class << self
    # Returns the hash digest of the given string
    # def User.digest(string)
    # def self.digest(string)
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    # def User.new_token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

end
