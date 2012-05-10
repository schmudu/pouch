class UserMailer < ActionMailer::Base
  default from: "noreply@lessonpouch.com"
  default to: 'support@lessonpouch.com'

  def contact_mail(subject, message)
    @message = message
    mail(:subject => subject)
  end
end
