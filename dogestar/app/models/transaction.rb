class Transaction < ActiveRecord::Base
  belongs_to :service
  belongs_to :buyer, :class_name => "User"
  has_one :review, dependent: :destroy

  validates :appt_time, presence: true

  scope :of_user, ->(uid) { where(buyer_id: uid) }
  scope :future, -> { where("appt_time > ?", Time.now) }
  scope :active, -> { where status: :ok }

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

end

class TransactionObserver < ActiveRecord::Observer
  observe :transaction

  def after_save(transaction)
    if transaction.status == :ok
      OrderNotification.create(user_id: transaction.service.user_id, sender_id: transaction.buyer_id)
    elsif transaction.status == :buyer_cancel
      CancelNotification.create(user_id: transaction.service.user_id, sender_id: transaction.buyer_id)
    elsif transaction.status == :seller_cancel
      CancelNotification.create(user_id: transaction.buyer_id, sender_id: transaction.service.user_id)
    end
  end

end