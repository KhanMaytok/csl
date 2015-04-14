class Notifier < ActionMailer::Base
  default from: "faelpa_12@hotmail.com"

  def welcome(user, body)
    @user = user
    @body = body
    mail(to: 'f.pena.jacobo@gmail.com', subject: 'Mensaje de ' + @user )
  end

end
