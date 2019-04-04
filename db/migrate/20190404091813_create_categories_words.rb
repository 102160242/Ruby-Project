class CreateCategoriesWords < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_words, :id => false do |t|
      t.references :category, foreign_key: true, index: true
      t.references :word, foreign_key: true, index: true
    end
  end
end
