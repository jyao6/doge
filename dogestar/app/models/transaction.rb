class Transaction < ActiveRecord::Base
	belongs_to :service
	belongs_to :buyer, :class_name => "User"

	scope :of_user, ->(uid) { where(buyer_id: uid) }

end
