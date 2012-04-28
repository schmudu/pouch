class ApplicationController < ActionController::Base
  include ConstantsHelper
  protect_from_forgery

  #used for testing purposes, comment out line below when pushing to production
  before_filter :authenticate_test_user

  private
  def authenticate_test_user
    authenticate_or_request_with_http_digest("Application") do |name|
      TEST_USERS[name]
    end
  end 
end
