class AddCreatedIpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_ip, :string
    add_index :users, :created_ip
  end
end
