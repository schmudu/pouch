class AddDownloadCountToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :download_count, :integer, :default => 0
  end
end
