class Word < ApplicationRecord
    @word_class = ["noun", "verb", "adj", "adv"].freeze
    has_one_attached :image
    has_and_belongs_to_many :users
    has_and_belongs_to_many :categories

    before_destroy do 
        users.clear
        categories.clear
    end
    validates :word, presence: true
    validates :meaning, presence: true
    validates :word_class, presence:true, numericality: true, inclusion: {in: 1..4}

    class << self
        def word_class_name(index)
            return @word_class[index]
        end
        def word_class_index(class_name)
            return @word_class.find_index(class_name)
        end
    end
end
