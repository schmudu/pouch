class CreateResourceTopics < ActiveRecord::Migration
  def change
    create_table :resource_topics do |t|
      t.integer :resource_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
