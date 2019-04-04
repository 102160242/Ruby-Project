class CreateAnswersQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :answers_questions, id: false do |t|
      t.references :answer, foreign_key: true, index: true
      t.references :question, foreign_key: true, index: true
    end
    add_index :answers_questions, [:answer_id, :question_id], unique: true
  end
end
