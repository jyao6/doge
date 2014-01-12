class Service < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :transactions

  validates :name, presence: true, length: { maximum: 30 }
  validates :price, presence: true, :numericality => { :only_integer => true , :greater_than => 0}
  validates :category, presence: true, :numericality => { :only_integer => true , :greater_than_or_equal_to => 0, :less_than => 6}
  validates :description, presence: true

  # scope :approved, :conditions => {:legitimized => 1}

  # CATS = { "Category 1"=>1, "Category 2"=>2, "Category 3"=>3}

  # def self.categories
  #   CATS.keys
  # end

  # def category
  #   CATS.key(read_attribute(:category))
  # end

  # def category=(n)
  #   write_attribute(:category, CATS[n])
  # end
end
