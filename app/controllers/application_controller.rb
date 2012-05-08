class ApplicationController < ActionController::Base
  include ConstantsHelper
  protect_from_forgery

  #used for testing purposes, comment out line below when pushing to production
  #before_filter :authenticate_member!
end
