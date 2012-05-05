class AddDownloadsToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :downloads, :integer, :default => 0
  end
end
