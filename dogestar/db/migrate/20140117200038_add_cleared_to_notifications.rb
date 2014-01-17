class AddClearedToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :cleared, :boolean, default: false
  end
end
