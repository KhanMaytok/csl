class UserMailer < ActionMailer::Base
  default from: "clinicalurensistemas@gmail.com"

  def welcome_email(body, user)
  	@user = user
  	@subject = user + ' : ' + body
    mail(to: 'f.pena.jacobo@gmail.com', subject: @subject)
  end
end
