class RemoveDescriptionFromAttachments < ActiveRecord::Migration
  def up
    remove_column :attachments, :description
  end

  def down
    add_column :attachments, :description, :string
  end
end
