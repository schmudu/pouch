class ChangeDownloadsDefaultToZero < ActiveRecord::Migration
  def up
    remove_column :users, :downloads
    add_column :users, :downloads, :integer, :default => 0
  end

  def down
    add_column :users, :downloads, :integer
  end
end
