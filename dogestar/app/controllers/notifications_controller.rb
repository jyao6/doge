class NotificationsController < ApplicationController
  before_action :for_signed_in

  def index
    @notifications = current_user.notifications
  end

  def clear
    Notification.where(user_id: current_user.id, cleared: false).each do |n|
      n.cleared = true
      n.save!
    end
    redirect_to notifications_path
  end

end
