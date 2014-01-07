class User < ActiveRecord::Base
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: { minimum: 6 }

  has_many :services, dependent: :destroy

end
