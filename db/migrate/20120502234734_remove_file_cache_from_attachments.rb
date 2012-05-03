class RemoveFileCacheFromAttachments < ActiveRecord::Migration
  def up
    remove_column :attachments, :file_cache
  end

  def down
    add_column :attachments, :file_cache, :string
  end
end
