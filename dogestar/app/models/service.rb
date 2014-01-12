class Service < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :transactions

  CATS = { "Category 1"=>1, "Category 2"=>2, "Category 3"=>3}

  def self.categories
    CATS.keys
  end

  def category
    CATS.key(read_attribute(:category))
  end

  def category=(n)
    write_attribute(:category, CATS[n])
  end

end
