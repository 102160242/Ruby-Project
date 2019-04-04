class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, unique: true
      t.string :email, unique:true
      t.string :password_digest
      t.string :avatar
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
