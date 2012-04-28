class AddAttachableAttributesToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :attachable_type, :string
  end
end
