class Category < ApplicationRecord
    has_and_belongs_to_many :words
    has_many :categories_test
    has_and_belongs_to_many :tests
end
