class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :url
      t.belongs_to :service

      t.timestamps
    end
  end
end
