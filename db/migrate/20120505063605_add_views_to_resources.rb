class AddViewsToResources < ActiveRecord::Migration
  def change
    add_column :resources, :views, :integer, :default => 0
    add_index :resources, :views
  end
end
