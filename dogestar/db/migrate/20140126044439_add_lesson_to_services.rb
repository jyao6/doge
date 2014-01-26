class AddLessonToServices < ActiveRecord::Migration
  def change
    add_column :services, :lesson, :boolean, default: false
    add_index :services, :lesson
  end
end
