class Word < ApplicationRecord
    has_one_attached :image
    has_and_belongs_to_many :users
    has_and_belongs_to_many :categories

    before_destroy do 
        users.clear
        categories.clear
    end
    validates :word, presence: true
    validates :meaning, presence: true
    validates :ipa, presence: true
    validates :word_class, presence:true, numericality: true, inclusion: {in: 1..4}

    @word_class = ["noun", "verb", "adj", "adv"].freeze

    class << self
        def search(key)
            if(key != "" && !key.nil?)
                where("word LIKE ?", "%#{key}%")
            else
                all
            end
        end

        def learnt(user_id, val = true)
            if val
                ids = UsersWord.select(:word_id)
                            .where(user_id: user_id)
                            .map {|x| x.word_id}
                where(id: ids)
            else
                ids = UsersWord.select(:word_id)
                            .where(user_id: user_id)
                            .map {|x| x.word_id}
                where.not(id: ids)
            end
        end

        def word_class_name(index)
            return @word_class[index - 1]
        end

        def word_class_index(class_name)
            return @word_class.find_index(class_name)
        end
    end
end
