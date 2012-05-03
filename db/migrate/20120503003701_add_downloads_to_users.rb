class AddDownloadsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :downloads, :integer
    add_index :users, :downloads
  end
end
