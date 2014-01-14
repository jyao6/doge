class User < ActiveRecord::Base
  has_many :services, dependent: :destroy
  has_many :reviews
  has_many :sent, :class_name => "Message"
  has_many :received, :class_name => "Message"

  #TODO: medium and thumb size options should be altered. these were defaults. also need actual default photo!
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/avatars/:style/missing.png"

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates_attachment :avatar, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
  :size => { :in => 0..3.megabytes }

  before_save { email.downcase! }
  before_create :create_remember_token

  def User.new_remember_token
      SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
  end

end
