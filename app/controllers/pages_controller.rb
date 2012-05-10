class PagesController < ApplicationController
  include ApplicationHelper

  def mail_sent_confirmation
    @title = 'Email Sent'
  end

  def contact
    @title = 'Contact Us'

    #send email
    #UserMailer.contact_mail.deliver
  end

  def send_contact_mail
    name = params[:name]
    email = params[:email]
    subject = params[:subject]
    message = params[:message]
    flash[:notice] =[] 

    if(!(email.nil?) && (!email.empty?))
      flash_message(:notice, "The email address entered seems to be incorrect") if (/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/ =~ email).nil?
    end

    flash_message(:notice, "Please enter a subject for the email") if ((subject.nil?) || (subject.empty?))
    flash_message(:notice, "Please enter message for the email") if ((message.nil?) || (message.empty?))

    unless flash[:notice].empty?
      render 'contact'
    else
      UserMailer.contact_mail(subject, message).deliver
      redirect_to mail_sent_confirmation_path
    end
  end

  def home
    @title = 'Home'
  end

  def about
    @title = 'About'
  end

  def not_found
    @title = 'Page Not Found'
  end

  def terms
    @title = 'Terms of Use'
  end

  def privacy
    @title = 'Privacy Policy'
  end

  def unauthorized
    @title = 'Unauthorized'
  end
end
