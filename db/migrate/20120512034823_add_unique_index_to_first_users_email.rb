class AddUniqueIndexToFirstUsersEmail < ActiveRecord::Migration
  def change
    add_index :first_users, :email, :unique => true
  end
end
