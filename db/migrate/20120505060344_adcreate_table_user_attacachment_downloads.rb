class AdcreateTableUserAttacachmentDownloads < ActiveRecord::Migration
  def up
    create_table :user_attachment_downloads do |t|
      t.column :user_id, :integer, :null => false
      t.column :attachment_id, :integer, :null => false
    end

    add_index :user_attachment_downloads, :user_id
    add_index :user_attachment_downloads, :attachment_id
  end

  def down
    remove_index :user_attachment_downloads, :user_id
    remove_index :user_attachment_downloads, :attachment_id
    drop_table :user_attachment_downloads
  end
end
