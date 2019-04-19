class Answer < ApplicationRecord
    belongs_to :question
    validates :question_id, presence: true
    validates :answer_content, presence: true
    validates :right_answer, inclusion: { in: [ true, false ] }
    class << self
        def search(key)
            if(key != "" && !key.nil?)
                joins(:question)
                .where("answers.answer_content LIKE ? OR answers.question_id LIKE ?", "%#{key}%", "%#{key}%")
            else
                all
            end
        end
    end
end
