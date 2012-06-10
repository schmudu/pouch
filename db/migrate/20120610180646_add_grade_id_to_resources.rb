class AddGradeIdToResources < ActiveRecord::Migration
  def change
    add_column :resources, :grade_id, :integer
    add_index :resources, :grade_id
  end
end
