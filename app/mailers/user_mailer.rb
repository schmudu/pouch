class UserMailer < ActionMailer::Base
  default from: "site@lessonpouch.com"

  def contact_mail
    mail(:to => 'patrick@lessonpouch.com', :subject => 'Contact Email')
  end
end
