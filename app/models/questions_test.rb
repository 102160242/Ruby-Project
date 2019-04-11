class QuestionsTest < ApplicationRecord
  belongs_to :question
  belongs_to :test
  belongs_to :answer, foreign_key: 'chosen_answer_id'
end
