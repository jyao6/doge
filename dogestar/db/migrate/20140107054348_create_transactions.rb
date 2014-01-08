class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.datetime :appt_time
      t.decimal :price, precision: 2
      t.belongs_to :service
      t.belongs_to :buyer

      t.timestamps
    end
    add_foreign_key :transactions, :services
    add_foreign_key :transactions, :users, :column => 'buyer_id'
    add_index :transactions, :service_id
    add_index :transactions, :buyer_id
  end
end
