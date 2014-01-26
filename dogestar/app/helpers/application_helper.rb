module ApplicationHelper

  def full_title(page_title)
    base_title = "Cadenza"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  #TODO: this feels a bit wasteful to query on every page
  # maybe we should look into push notifications? or store these in session (probably quickest fix).
  def find_notifications
    if signed_in?
      types = Notification::Clearable.subclasses
      types.each do |t|
        msg = t.flash_msg(current_user.id)
        if msg
          @can_clear = true
          flash.now[t.name.downcase] = msg
        end
      end
      unread = MsgNotification.flash_msg(current_user.id)
      if unread
        flash.now[:unread_msgs] = unread
      end
    end
  end

end
