class Message < ActiveRecord::Base
	belongs_to :from, :class_name => "User"
	belongs_to :to, :class_name => "User"
	has_one :notification, as: :notifiable
end
