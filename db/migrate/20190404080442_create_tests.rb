class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :score
      t.timestamps
    end
  end
end
