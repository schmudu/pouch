class RemoveDownloadCountFrommAttachments < ActiveRecord::Migration
  def up
    remove_column :attachments, :download_count
  end

  def down
    add_column :attachments, :download_count, :integer, :default => 0
  end
end
