class AddForeignKeyToPhotos < ActiveRecord::Migration
  def change
    add_foreign_key :photos, :services
    add_index :photos, :service_id
  end
end
