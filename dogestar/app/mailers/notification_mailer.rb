class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"

  def order_alert(notification)
  	@user = notification.user
  	@msg = notification.description
  	mail(to: @user.email, subject: notification.short_description)
  end

  def msg_alert(msg)
  	#TODO
  	@user = msg.user
  	mail(to: @user.email, subject: msg.short_description)
  end

end
