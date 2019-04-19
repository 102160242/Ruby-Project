class Category < ApplicationRecord
    has_one_attached :image
    has_and_belongs_to_many :words
    has_many :tests, dependent: :destroy
    has_many :questions, dependent: :destroy
    before_destroy do
        words.clear
    end
    VALID_NAME_REGEX = /\A[a-z]+[a-z0-9 ]*\z/i
    validates :name, presence: true, length: { minimum: 6 }, format: {with: VALID_NAME_REGEX}
    class << self
        def search(key)
            if(key != "" && !key.nil?)
                where("name LIKE ?", "%#{key}%")
            else
                all
            end
        end
    end
end
