class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer
    add_index :users, :status
  end
end
