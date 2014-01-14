class AddAttachmentAvatarToUsers < ActiveRecord::Migration
  def self.up
  	remove_column :users, :bio_pic

    change_table :users do |t|
      t.attachment :avatar
    end
  end

  def self.down
  	add_column :users, :bio_pic, :string
    drop_attached_file :users, :avatar
  end
end
