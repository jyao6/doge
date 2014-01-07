class Service < ActiveRecord::Base
	belongs_to :user
	has_many :photos, dependent: :destroy
	has_many :reviews, dependent: :destroy
	has_many :transactions
end
