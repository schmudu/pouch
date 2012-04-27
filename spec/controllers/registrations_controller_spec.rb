require 'devise/test_helpers'
require 'spec_helper'

#describe RegistrationsControllerTest < ActionController::TestCase
describe Users::RegistrationsController do
    #include Devise::TestHelpers
    render_views
=begin
    it "should respond to build resource" do
       setup_controller_for_warden
       request.env["devise.mapping"] = Devise.mappings[:user]
       ActionDispatch::Request.any_instance.stub(:remote_ip).and_return("192.168.0.1")
       get 'create'
       response.should be_success
   end

    it "should respond to new" do 
      get '/users/sign_up'
      response.should be_success
    end
=end
end