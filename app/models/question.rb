class Question < ApplicationRecord
    has_and_belongs_to_many :tests
    has_many :answers
    belongs_to :category, dependent: :destroy

    before_destroy do
        tests.clear
    end
    validates :question_content, presence: true, length: {minimum: 10}
end
