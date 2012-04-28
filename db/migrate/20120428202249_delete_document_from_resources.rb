class DeleteDocumentFromResources < ActiveRecord::Migration
  def up
    remove_column :resources, :document
  end

  def down
    add_column :resources, :document, :string
  end
end
