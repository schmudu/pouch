class AddFileCacheToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :file_cache, :string
  end
end
