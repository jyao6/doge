class Notification < ActiveRecord::Base
  include CommunityHelper

  belongs_to :user
  belongs_to :sender, :class_name => "User"
  belongs_to :notifiable, :polymorphic => true

  before_save :send_email

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
    NotificationMailer.order_alert(self).deliver unless self.cleared?
  end

  private

    def pretty_date(time)
      utc2current(time).to_formatted_s(:long)
    end
end

class Clearable < Notification
  def short_description
    "#{sender.name} made a #{self.class.instance_eval{@noun}}"
  end
end

class OrderNotification < Clearable
  @noun = 'new order'

  def description
    "#{sender.name} ordered #{notifiable.service.name} for #{pretty_date(notifiable.appt_time)}."
  end
end

class CancelNotification < Clearable
  @noun = 'cancellation'

  def description
    "#{sender.name} cancelled the order for #{notifiable.service.name} for #{pretty_date(notifiable.appt_time)}."
  end
end

class MsgNotification < Notification
  @noun = 'unread message'

  def send_email
    NotificationMailer.msg_alert(self.notifiable).deliver
  end
end