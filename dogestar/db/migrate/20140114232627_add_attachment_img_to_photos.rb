class AddAttachmentImgToPhotos < ActiveRecord::Migration
  def change
  	remove_column :photos, :url
  	add_attachment :photos, :img
  end
end
