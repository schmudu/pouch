class CreateUserQueries < ActiveRecord::Migration
  def change
    create_table :user_queries do |t|
      t.string :content

      t.timestamps
    end
  end
end
