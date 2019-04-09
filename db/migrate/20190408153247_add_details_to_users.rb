class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    ## Database authenticatable
    add_column :users, :encrypted_password, :string, null: false, default: ""
    
    ## Recoverable  
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :users, :remember_created_at, :datetime

    ## Trackable
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string

    ## Confirmable
    #add_column :users, :confirmation_token, :string
    #add_column :users, :confirmed_at, :datetime
    #add_column :users, :confirmation_sent_at, :datetime
    #add_column :users, :unconfirmed_email, :string

    ## Lockable
    #add_column :users, :failed_attempts, :integer
    #add_column :users, :unlock_token, :string
    #add_column :users, :locked_at, :datetime
    
  end
end
