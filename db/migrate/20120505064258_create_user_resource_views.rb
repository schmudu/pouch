class CreateUserResourceViews < ActiveRecord::Migration
  def change
    create_table :user_resource_views do |t|
      t.integer :user_id, :null => true
      t.integer :resource_id, :null => false

      t.timestamps
    end

    add_index :user_resource_views, :user_id
    add_index :user_resource_views, :resource_id
  end
end
