class Review < ActiveRecord::Base
	belongs_to :transaction

	validates :rating, presence: true, :numericality => { :only_integer => true , :greater_than => 0, :less_than => 6}
end
