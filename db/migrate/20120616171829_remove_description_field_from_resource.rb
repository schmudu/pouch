class RemoveDescriptionFieldFromResource < ActiveRecord::Migration
  def up
    remove_column :resources, :description
  end

  def down
    add_column :resources, :description, :string
  end
end
