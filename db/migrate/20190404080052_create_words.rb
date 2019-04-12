class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :word
      t.string :ipa
      t.string :meaning
      t.integer :word_class

      t.timestamps
    end
  end
end
