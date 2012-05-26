class RemoveQuoteTable < ActiveRecord::Migration
  def up
    drop_table :quotes
  end

  def down
    create_table :quotes do |t|
      t.string :message
      t.string :auauthor

      t.timestamps
    end
  end
end
