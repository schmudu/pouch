class RemoveQueryTable < ActiveRecord::Migration
  def up
    drop_table :queries
  end

  def down
    create_table :queries do |t|
      t.string :content

      t.timestamps
    end
  end
end
