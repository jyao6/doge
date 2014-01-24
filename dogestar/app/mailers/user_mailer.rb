class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to Cadenza!')
  end

  def reset_password(user, token)
    @token = token
    @user = user
    mail(to: @user.email, subject: 'Reset Your Password')
  end

end
