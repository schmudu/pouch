require 'devise/test_helpers'
require 'spec_helper'

describe Users::RegistrationsController do
  render_views

  before(:each) do
     request.env["devise.mapping"] = Devise.mappings[:user]
     @password = 'aaaAAA6'
     @password_confirmation = 'aaaAAA6'
     @screen_name = 'hubba'
     @email = "abc@abc.com"
  end

  describe "create" do
    #login_user

    it "should change user count from 0 to 1" do
       lambda do
         post 'create', :user => {:password => @password, :password_confirmation => @password_confirmation, :screen_name => @screen_name, :email => @email}
       end.should change(User, :count).from(0).to(1)
    end

    it "should populate create_ip field" do
       post 'create', :user => {:password => @password, :password_confirmation => @password_confirmation, :screen_name => @screen_name, :email => @email}
       user = User.first
       user.created_ip.should_not be_nil
    end
  end
end