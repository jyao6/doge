class Transaction < ActiveRecord::Base
  belongs_to :service
  belongs_to :buyer, :class_name => "User"
  has_one :review, dependent: :destroy
  has_many :notifications, :as => :notifiable

  after_save :send_notifications

  validates :appt_time, presence: true

  scope :of_user, ->(uid) { where(buyer_id: uid) }
  scope :future, -> { where("appt_time > ?", Time.now) }
  scope :past, -> { where("appt_time < ?", Time.now) }
  scope :active, -> { where status: :ok }

  paginates_per 10

  STATUSES = { ok: 0, buyer_cancel: 1, seller_cancel: 2 }

  def status
    STATUSES.key(read_attribute(:status))
  end

  def status=(s)
    write_attribute(:status, STATUSES[s])
  end

  def seller
    self.service.user
  end

  def send_notifications
    if self.status == :ok
      record = OrderNotification.new(user_id: self.service.user_id, sender_id: self.buyer_id)
    elsif self.status == :buyer_cancel
      record = CancelNotification.new(user_id: self.service.user_id, sender_id: self.buyer_id)
    elsif self.status == :seller_cancel
      record = CancelNotification.new(user_id: self.buyer_id, sender_id: self.service.user_id)
    end
    record.notifiable = self
    record.save
  end

end
