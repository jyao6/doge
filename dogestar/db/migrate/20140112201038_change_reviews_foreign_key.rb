class ChangeReviewsForeignKey < ActiveRecord::Migration
  def change
  	remove_foreign_key :reviews, :services
  	remove_foreign_key :reviews, :users
  	remove_index :reviews, :service_id
  	remove_index :reviews, :user_id
  	remove_column :reviews, :user_id
  	remove_column :reviews, :service_id
  	add_column :reviews, :transaction_id, :integer, references: :transactions   
  	add_foreign_key :reviews, :transactions
  	add_index :reviews, :transaction_id
  end
end
