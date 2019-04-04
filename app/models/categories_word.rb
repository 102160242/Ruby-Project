class CategoriesWord < ApplicationRecord
  belongs_to :word
  belongs_to :category
end
