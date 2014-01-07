class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :price
      t.integer :category
      t.text :description
      t.boolean :legitimized
      t.belongs_to :user

      t.timestamps
    end
    add_foreign_key :services, :users
    add_index :services, :user_id
    add_index :services, :category
  end
end
