class CreateDefault < ActiveRecord::Migration
  def change
    change_column :services, :legitimized, :boolean, :default => false
  end
end
