class Test < ApplicationRecord
    belongs_to :category
    belongs_to :user
    has_and_belongs_to_many :questions
    validates :user_id, presence: true
    class << self
        def search(key)
            if(key != "" && !key.nil?)
                where("id LIKE ?", "%#{key}%")
            else
                all
            end
        end

        def filter_(key)
            if(!key.nil?) 
                if key == "za"
                    order("id DESC")
                else
                    order("id ASC") # Order mac dinh theo A-Z
                end               
            else
                all
            end
        end
    end
end
