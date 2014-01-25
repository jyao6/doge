class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"

  def order_alert(notification)
  	@user = notification.user
  	@msg = notification.description
  	mail(to: @user.email, subject: notification.short_description)
  end

  def msg_alert(msg)
    @msg = msg
  	mail(to: @msg.to.email, subject: "#{@msg.from.name} sent you a message")
  end

end
