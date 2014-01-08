class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :review
      t.belongs_to :user
      t.belongs_to :service

      t.timestamps
    end
    add_foreign_key :reviews, :services
    add_foreign_key :reviews, :users
    add_index :reviews, :service_id
    add_index :reviews, :user_id
  end
end
