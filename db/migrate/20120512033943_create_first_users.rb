class CreateFirstUsers < ActiveRecord::Migration
  def change
    create_table :first_users do |t|
      t.string :email

      t.timestamps
    end
  end
end
