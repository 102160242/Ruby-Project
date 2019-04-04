class Question < ApplicationRecord
    has_and_belongs_to_many :tests
    has_and_belongs_to_many :answers
    belongs_to :category

    before_destroy do
        categories.clear
        answers.clear
        tests.clear
    end
end
