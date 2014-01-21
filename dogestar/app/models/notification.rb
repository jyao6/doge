class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :sender, :class_name => "User"
  belongs_to :notifiable, :polymorphic => true

  after_save :send_email

  @noun = 'notification'

  def self.flash_msg(user_id)
  	count = self.where(user_id: user_id, cleared: false).count
  	if count > 0
  	  word = @noun.pluralize(count)
      "You have #{count} #{word}."
    end
  end

  def description
    "New notification from #{sender.name}."
  end

  def send_email
    NotificationMailer.order_alert(self).deliver
  end
end

class OrderNotification < Notification
  @noun = 'new order'

  def short_description
    "#{sender.name} made a new order"
  end

  def description
    "#{sender.name} ordered #{notifiable.service.name} for #{notifiable.appt_time}."
  end

end

class CancelNotification < Notification
  @noun = 'cancellation'

  def short_description
    "#{sender.name} cancelled an order"
  end

  def description
    "#{sender.name} cancelled the order for #{notifiable.service.name} for #{notifiable.appt_time}."
  end

end

class MsgNotification
  #TODO
  def short_description
    "#{sender.name} sent you a message"
  end

  def description
  end

  def send_email
    NotificationMailer.msg_alert(self).deliver
  end
end