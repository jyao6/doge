class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :sender, :class_name => "User"

  @noun = 'notification'

  def self.flash_msg(user_id)
  	count = self.where(user_id: user_id).count
  	if count > 0
  	  word = @noun.pluralize(count)
      "You have #{count} new #{word}."
    end
  end
end

class OrderNotification < Notification
  @noun = 'order'
end

class CancelNotification < Notification
  @noun = 'cancellation'
end