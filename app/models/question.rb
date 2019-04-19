class Question < ApplicationRecord
    has_and_belongs_to_many :tests
    has_many :answers, dependent: :destroy
    belongs_to :category

    before_destroy do
        tests.destroy
        #answers.destroy
    end
    validates :question_content, presence: true, length: {minimum: 10}
    class << self
        def search(key)
            if(key != "" && !key.nil?)
                joins(:category)
                .where("questions.question_content LIKE ? OR categories.name LIKE ?", "%#{key}%", "%#{key}%")
            else
                all
            end
        end
    end
end
