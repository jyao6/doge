class Message < ActiveRecord::Base
  belongs_to :from, :class_name => "User"
  belongs_to :to, :class_name => "User"
  has_one :notification, as: :notifiable

  after_save :send_notification

  def send_notification
    record = MsgNotification.new(user_id: self.to_id, sender_id: self.from_id)
    record.notifiable = self
    record.save
  end
end
