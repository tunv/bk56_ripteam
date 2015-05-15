class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :dob
      t.string :date
      t.integer :repuation

      t.timestamps
    end
  end
end
