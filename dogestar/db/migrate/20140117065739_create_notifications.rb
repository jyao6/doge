class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :type
      t.integer :sender_id
    end
    add_index :notifications, :user_id
    add_foreign_key :notifications, :users
    add_foreign_key :notifications, :users, :column => 'sender_id'
  end
end
