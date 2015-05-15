class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :questions, :Title, :title
    rename_column :questions, :Description, :description
    rename_column :questions, :Vote, :vote
    rename_column :questions, :Unvote, :unVote
    rename_column :questions, :Content, :content
    
    rename_column :answers, :description, :content
  end
end
