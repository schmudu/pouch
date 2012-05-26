class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :message
      t.string :auauthor

      t.timestamps
    end
  end
end
