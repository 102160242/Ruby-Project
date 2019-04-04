class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.text :answer_content
      t.boolean :right_answer

      t.timestamps
    end
  end
end
