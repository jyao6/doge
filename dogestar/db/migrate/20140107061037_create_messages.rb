class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.belongs_to :to
      t.belongs_to :from

      t.timestamps
    end
    add_foreign_key :messages, :users, :column => 'to_id'
    add_foreign_key :messages, :users, :column => 'from_id'
    add_index :messages, :to_id
    add_index :messages, :from_id
  end
end
