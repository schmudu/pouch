require 'spec_helper'

describe UsersController do
include Devise::TestHelpers
  include ConstantsHelper
  render_views
 
  describe "GET 'account'" do
     before(:each) do
      @user = FactoryGirl.create(:user)
      @user.confirm!

      sign_in @user
    end

    it "returns http success" do
      get 'account'
      response.should be_success
      response.should have_selector('body', :content => "Manage Account Settings")
    end

    it "should redirect user if not signed in" do
      sign_out @user
      get 'account'
      response.should redirect_to(new_user_session_path)
    end
  end

end
