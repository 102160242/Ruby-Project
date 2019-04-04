class CreateQuestionsTests < ActiveRecord::Migration[5.2]
  def change
    create_table :questions_tests, id: false do |t|
      t.references :question, foreign_key: true, index: true
      t.references :test, foreign_key: true, index: true
    end
    add_index :questions_tests, [:test_id, :question_id], unique: true
  end
end
