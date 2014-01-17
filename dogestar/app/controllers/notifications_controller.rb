class NotificationsController < ApplicationController

  def feed

  end

  def clear
    Notification.destroy_all(user_id: current_user.id)
    render 'feed'
  end

end
