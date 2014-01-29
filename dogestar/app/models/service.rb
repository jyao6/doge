class Service < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy
  belongs_to :cover_photo, class_name: "Photo"
  has_many :transactions

  validates :name, presence: true, length: { maximum: 30 }
  validates :price, presence: true, :numericality => { :only_integer => true , :greater_than => 0}
  validates :category, presence: true, :numericality => { :only_integer => true , :greater_than_or_equal_to => 0, :less_than => 6}
  validates :description, presence: true

  scope :approved, :conditions => {:legitimized => 1}

  paginates_per 20

  CAT_DICT = { "Music"=>0, "Culinary"=>1, "Academic"=>2, "Beauty"=> 3, "Photography"=>4, "Fashion"=>5}

  def self.categories
    CAT_DICT.keys
  end

  def album_cover
    if cover_photo.nil?
      photos.first_or_initialize.img
    else
      cover_photo.img
    end
  end

  def category
    CAT_DICT.key(read_attribute(:category))
  end

  def category=(n)
    write_attribute(:category, CAT_DICT[n])
  end
end
