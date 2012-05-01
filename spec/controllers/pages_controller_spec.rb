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
        response.should have_selector('body', :content => 'My Account')
    end

    it "should have sign out link if signed in" do
        # user = double('user')
        # request.env['warden'].stub :authenticate! => user
        # controller.stub :current_user => user 
        login_user

        get 'home'
        response.should have_selector('body', :content => ConstantsHelper::LINK_SIGN_OUT)
    end

    it "should have sign in link if user signed out" do
        request.env['warden'].stub(:authenticate!).
        and_throw(:warden, {:scope => :user})
        controller.stub :current_user => nil

        get 'home'
        response.should have_selector('body', :content => ConstantsHelper::LINK_SIGN_IN)
    end

    it "should have an terms link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => 'Terms of Use')
    end

    it "should have an privacy link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => 'Privacy')
    end

    it "should have an contact link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => 'Contact')
    end

    it "should have an about link in the footer" do
        get 'home'
        response.should have_selector('ul', :content => 'About')
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
end
