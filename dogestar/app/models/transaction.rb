class Transaction < ActiveRecord::Base
  belongs_to :service
  belongs_to :buyer, :class_name => "User"
  has_one :review, dependent: :destroy

  scope :of_user, ->(uid) { where(buyer_id: uid) }
  scope :future, -> { where("appt_time > ?", Time.now) }
  scope :active, -> { where status: :ok }

  STATUSES = { ok: 0, cancelled: 1}

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
