class Answer < ApplicationRecord
    has_and_belongs_to_many :questions
    validates :question_id, presence: true
    validates :answer_content, presence: true
    validates :right_answer, presence: true
end
