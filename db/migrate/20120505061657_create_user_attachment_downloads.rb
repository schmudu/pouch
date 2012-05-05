class CreateUserAttachmentDownloads < ActiveRecord::Migration
  def change
    create_table :user_attachment_downloads do |t|
      t.integer :user_id
      t.integer :attachment_id

      t.timestamps
    end

    add_index :user_attachment_downloads, :user_id
    add_index :user_attachment_downloads, :attachment_id
  end
end
