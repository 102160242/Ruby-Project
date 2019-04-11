class CreateUsersWords < ActiveRecord::Migration[5.2]
  def change
    create_table :users_words, :id => false do |t|
      t.references :user, foreign_key: true, index: true
      t.references :word, foreign_key: true, index: true
      t.timestamps
    end
    add_index :users_words, [:user_id, :word_id], unique: true
  end
end
