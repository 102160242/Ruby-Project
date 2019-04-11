class Answer < ApplicationRecord
    belongs_to :question
    validates :question_id, presence: true
    validates :answer_content, presence: true
    validates :right_answer, presence: true
end
