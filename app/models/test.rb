class Test < ApplicationRecord
    belongs_to :category
    belongs_to :user
    has_and_belongs_to_many :questions
    validates :user_id, presence: true
    before_destroy do
        questions.clear
    end
end
