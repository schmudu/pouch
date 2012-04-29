class ChangeScreenNameToUnique < ActiveRecord::Migration
  def change
    add_index :users, :screen_name,:unique => true
  end

  def down
    remove_index :users, :screen_name
  end
end
