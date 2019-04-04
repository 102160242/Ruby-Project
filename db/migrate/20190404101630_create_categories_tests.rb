class CreateCategoriesTests < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_tests, id: false do |t|
      t.references :test, foreign_key: true, index: true
      t.references :category, foreign_key: true, index: true
    end

    add_index :categories_tests, [:test_id, :category_id], unique: true
  end
end
