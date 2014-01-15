class Photo < ActiveRecord::Base
  belongs_to :service

  has_attached_file :img, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/user-albums/:style/missing.png"

  validates_attachment :img, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
  :size => { :in => 0..3.megabytes }
end
