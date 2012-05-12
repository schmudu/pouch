require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'coming_soon'" do
    it "returns http success" do
      get 'coming_soon'
      response.should be_success
    end
  end

  describe "GET 'coming_soon_confirmation'" do
    it "returns http success" do
      get 'coming_soon_confirmation'
      response.should be_success
    end
  end

  describe "POST 'submit_email_coming_soon'" do
    before(:each) do
      FactoryGirl.create(:first_user, {:email => 'something@crazy.com'})
    end

    def valid_attributes
      {:email => "something@something.com"}
    end

    it "should be success" do
      post 'submit_email_coming_soon', valid_attributes
      response.should redirect_to('/coming_soon_confirmation')
    end

    it "should be re-render coming soon page if email is nil" do
      post 'submit_email_coming_soon', {:email => nil}
      response.should render_template('coming_soon')
    end

    it "should re-render coming soon page if email is the wrong format" do
      post 'submit_email_coming_soon', {:email => 'laksdjfkl.com'}
      response.should render_template('coming_soon')
    end

    it "should re-render coming soon page if email is a duplicate" do
      post 'submit_email_coming_soon', {:email => 'something@crazy.com'}
      response.should render_template('coming_soon')
    end
  end
end