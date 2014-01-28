class NotificationsController < ApplicationController
  before_action :for_signed_in

  def index
    @notifications = Notification::Clearable.where(user_id: current_user.id).order(created_at: :desc).page(params[:page])
  end

  def clear
    Notification::Clearable.where(user_id: current_user.id, cleared: false).each do |n|
      n.cleared = true
      n.save!
    end
    redirect_to notifications_path
  end

end
