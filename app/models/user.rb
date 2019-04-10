class User < ApplicationRecord
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable
    #attr_accessor :remember_token
    has_many :active_relationships,  class_name:  "Relationship",
                foreign_key: "follower_id",
                dependent:   :destroy
    has_many :passive_relationships, class_name:  "Relationship",
                foreign_key: "followed_id",
                dependent:   :destroy
    has_many :following, through: :active_relationships,  source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    has_and_belongs_to_many :words    
    has_many :tests, dependent: :destroy

    before_destroy { words.clear }

    before_save { self.email = email.downcase }
    #VALID_NAME_REGEX = /\A[a-z0-9]+[\w+\-.]+\z/i
    #validates :username, presence: true, length: { maximum: 15, minimum: 6 },
     #               format: { with: VALID_NAME_REGEX }
    VALID_EMAIL_REGEX = /\A[a-z0-9]+[\w+\.-]+@[0-9a-z\.-]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    #has_secure_password
    #validates :password_digest, presence: true, length: { minimum: 6 }  
    
  # Returns the hash digest of the given string.
  # def User.digest(string)
  #   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
  #                                                 BCrypt::Engine.cost
  #   BCrypt::Password.create(string, cost: cost)
  # end

  # def User.new_token
  #   SecureRandom.urlsafe_base64
  # end

  # def remember
  #   self.remember_token = User.new_token
  #   update_attribute(:remember_digest, User.digest(remember_token))
  # end

  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  # def forget
  #   update_attribute(:remember_digest, nil)
  # end
end
