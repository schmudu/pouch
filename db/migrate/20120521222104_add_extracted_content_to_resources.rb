class AddExtractedContentToResources < ActiveRecord::Migration
  def change
    add_column :resources, :extracted_content, :string
  end
end
