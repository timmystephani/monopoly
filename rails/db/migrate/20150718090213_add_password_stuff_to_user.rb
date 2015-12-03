class AddPasswordStuffToUser < ActiveRecord::Migration
  def change
  	add_column :users, :password_hash, :string
  	add_column :users, :password_salt, :string
  	add_column :users, :auth_token, :string

  	add_index :users, :password_hash, :unique => true
  	add_index :users, :password_salt, :unique => true
    add_index :users, :auth_token, :unique => true
  end
end
