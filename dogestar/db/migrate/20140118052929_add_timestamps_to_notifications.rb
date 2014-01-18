class AddTimestampsToNotifications < ActiveRecord::Migration
  def change
  	change_table(:notifications) { |t| t.timestamps }
  end
end
