class CreateQuotesTable < ActiveRecord::Migration
  def up    
    create_table :quotes do |t|
      t.string :message
      t.string :author

      t.timestamps
    end
  end

  def down
    drop_table :quotes
  end
end
