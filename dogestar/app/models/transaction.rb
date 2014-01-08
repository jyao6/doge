class Transaction < ActiveRecord::Base
	belongs_to :service
	belongs_to :buyer, :class_name => "User"
end
