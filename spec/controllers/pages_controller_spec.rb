require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end

    it "should have my account link if signed in" do
        # user = double('user')
        # request.env['warden'].stub :authenticate! => user
        # controller.stub :current_user => user 
        login_user
        
        get 'home'
        response.should have_selector('body', :content => "#{I18n.t 'accounts.links'}")
    end

    it "should have sign out link if signed in" do
        # user = double('user')
        # request.env['warden'].stub :authenticate! => user
        # controller.stub :current_user => user 
        login_user

        get 'home'
        response.should have_selector('body', :content => "#{I18n.t 'sessions.sign_out'}")
    end

    it "should have sign in link if user signed out" do
        request.env['warden'].stub(:authenticate!).
        and_throw(:warden, {:scope => :user})
        controller.stub :current_user => nil

        get 'home'
        response.should have_selector('body', :content => "#{I18n.t 'sessions.sign_in'}")
    end

    it "should have an terms link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => "#{I18n.t 'links.terms'}")
    end

    it "should have an privacy link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => "#{I18n.t 'links.privacy'}")
    end

    it "should have an contact link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => "#{I18n.t 'contact.links'}")
    end

    it "should have an about link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => "#{I18n.t 'links.about'}")
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'terms'" do
    it "returns http success" do
      get 'terms'
      response.should be_success
    end
  end

  describe "GET 'privacy'" do
    it "returns http success" do
      get 'privacy'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'unauthorized'" do
    it "returns http success" do
      get 'unauthorized'
      response.should be_success
    end
  end

  describe "POST 'send_contact_mail'" do
    def valid_attributes
      {:name => "Patrick", :email => "something@something.com", :subject => "Test Subject", :message => "This is my message."}
    end

    it "should be success" do
      post 'send_contact_mail', valid_attributes
      response.should redirect_to mail_sent_confirmation_path
    end

    it "should be success even if name is nil" do
      post 'send_contact_mail', valid_attributes.merge({:name => nil})
      response.should redirect_to mail_sent_confirmation_path
    end

    it "should be success even if email is nil" do
      post 'send_contact_mail', valid_attributes.merge({:email => nil})
      response.should redirect_to mail_sent_confirmation_path
    end

    it "should re-render mail form if email is the wrong format" do
      post 'send_contact_mail', valid_attributes.merge({:email => 'laksdjfkl.com'})
      response.should render_template('contact')
    end

    it "should re-render mail form if subject is nil" do
      post 'send_contact_mail', valid_attributes.merge({:subject => nil})
      response.should render_template('contact')
    end

    it "should re-render mail form if message is nil" do
      post 'send_contact_mail', valid_attributes.merge({:message => nil})
      response.should render_template('contact')
    end
  end

=begin
  describe "GET 'not_found'" do
    it "returns http success" do
      visit '/something_crazy.html'
      response.should render_template('not_found')
    end
  end
=end
end
