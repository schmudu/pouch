class AddDefaultStatusToUsers < ActiveRecord::Migration
  def self.up
    remove_index :users, :status
    remove_column :users, :status
    add_column :users, :status, :integer, :default => 0
    add_index :users, :status
  end

  def self.down
    add_column :users, :status, :integer
  end
end
