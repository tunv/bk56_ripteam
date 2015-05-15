class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :description
      t.integer :vote
      t.integer :unVote
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
