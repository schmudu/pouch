class UserMailer < ActionMailer::Base
  default from: "noreply@lessonpouch.com"
  default to: 'support@lessonpouch.com'

  def contact_mail(subject, message)
    @message = message
    mail(:subject => "Message From Site :: #{subject}")
  end
end
