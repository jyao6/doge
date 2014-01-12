class IncreasePricePrecision < ActiveRecord::Migration
  def self.up
   change_column :transactions, :price, :decimal, precision: 10, scale: 2
  end
end
