class ChangeNameColumnToTitleInResources < ActiveRecord::Migration
  def up
    remove_column :resources, :name
    add_column :resources, :title, :string
  end

  def down
    remove_column :resources, :title
    add_column :resources, :name, :string
  end
end
