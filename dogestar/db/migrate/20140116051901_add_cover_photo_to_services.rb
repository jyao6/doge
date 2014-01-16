class AddCoverPhotoToServices < ActiveRecord::Migration
  def change
    add_column :services, :cover_photo_id, :integer, references: :photos
    add_foreign_key :services, :photos, column: 'cover_photo_id'
  end
end
