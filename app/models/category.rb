class Category < ApplicationRecord
    has_and_belongs_to_many :words
    has_many :categories_test
    has_and_belongs_to_many :tests
    has_many :questions, dependent: :destroy
    before_destroy do
        words.clear
        tests.clear
    end
end
