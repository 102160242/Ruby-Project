class User < ApplicationRecord
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
    VALID_NAME_REGEX = /\A[a-z0-9]+[\w+\-.]+\z/i
    validates :username, presence: true, length: { maximum: 15, minimum: 6 },
                    format: { with: VALID_NAME_REGEX }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password_digest, presence: true, length: { minimum: 6 }
                  
end
