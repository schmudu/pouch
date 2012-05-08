module ConstantsHelper
  #testing
   TEST_FILE_PATH = File.join(Rails.root, '/test/downloads/hello.txt')
  
  #site wide
  WEB_SITE_NAME = "LessonPouch"

  #links
  LINK_SIGN_IN                  = "Sign In"
  LINK_SIGN_OUT                 = "Sign Out"
  LINK_SHARE_RESOURCE_BUTTON    = "Share Your Resource"
  LINK_SHARE_RESOURCE_MAIN      = "Share Resource"
  LINK_BROWSE_RESOURCE_MAIN     = "Browse"
  LINK_HOW_IT_WORKS             = "How It Works"
  LINK_MY_ACCOUNT               = "My Account"

  #ip gateway
  MAX_USERS_MINUTES_WINDOW = 10 
  MAX_USERS_FROM_IP = 10 

  #resources
  RESOURCE_ATTACHMENTS_MIN_NUM = 1

  #messages
  RESOURCE_UPDATED              = "Resource was updated"
  RESOURCE_UPDATED_NO_CHANGE    = "No update to the resource was made"
end