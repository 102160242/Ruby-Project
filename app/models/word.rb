class Word < ApplicationRecord
    has_and_belongs_to_many :users
    has_and_belongs_to_many :categories

    before_destroy do 
        users.clear
        categories.clear
    end
end
