class Transaction < ActiveRecord::Base
	belongs_to :service
	belongs_to :buyer, :class_name => "User"
  	has_many :reviews, dependent: :destroy

	scope :of_user, ->(uid) { where(buyer_id: uid) }

end
