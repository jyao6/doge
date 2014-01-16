class AddAvgRatingToServices < ActiveRecord::Migration
  def change
  	add_column :services, :avg_rating, :decimal, precision: 4, scale: 2
  end
end
