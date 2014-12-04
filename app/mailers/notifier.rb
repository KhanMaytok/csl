class Notifier < ActionMailer::Base
  default from: "faelpa_12@hotmail.com"

  def welcome(user)
    @user = user
    mail(to: @user, subject: 'Welcome to My Awesome Site')
  end

end
