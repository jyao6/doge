class AddLocationToOrder < ActiveRecord::Migration
  def change
  	add_column :transactions, :location, :string
  	add_column :services, :location, :string
  	add_column :services, :can_travel, :boolean, default: false
  end
end