class AddDocumentToResources < ActiveRecord::Migration
  def change
    add_column :resources, :document, :string
  end
end
