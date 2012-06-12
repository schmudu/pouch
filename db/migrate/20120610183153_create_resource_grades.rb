class CreateResourceGrades < ActiveRecord::Migration
  def change
    create_table :resource_grades do |t|
      t.integer :resource_id
      t.integer :grade_id

      t.timestamps
    end

    add_index :resource_grades, :resource_id
    add_index :resource_grades, :grade_id
  end
end
