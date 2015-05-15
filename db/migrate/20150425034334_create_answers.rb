class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :question, index: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
