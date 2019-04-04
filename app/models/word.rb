class Word < ApplicationRecord
    has_and_belongs_to_many :users
    has_and_belongs_to_many :categories

    before_destroy do 
        users.clear
        categories.clear
    end
    validates :word, presence: true
    validates :meaning, presence: true
    validates :word_class, numericality: true, inclusion: {in: 1..4}
end
