class Test < ApplicationRecord
    belongs_to :category
    belongs_to :user
    has_and_belongs_to_many :questions
    validates :user_id, presence: true
    before_destroy do
        questions.clear
    end

    class << self
        def search(key)
            if(key != "" && !key.nil?)
                joins(:user)
                .joins(:category)
                .where("users.name LIKE ? OR categories.name LIKE ?", "%#{key}%", "%#{key}%")
            else
                all
            end
        end
    end
end
