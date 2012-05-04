module ConstantsHelper
  #Testing
   TEST_USERS = { "plorenzo" => "myTwin", "rkelly" => "easternSho", "plee" => "shortGuy" }
   TEST_FILE_PATH = File.join(Rails.root, '/test/downloads/hello.txt')
  
  #Site Wide
  WEB_SITE_NAME = "LessonPouch"

  #Links
  LINK_SIGN_IN                  = "Sign In"
  LINK_SIGN_OUT                 = "Sign Out"
  LINK_SHARE_RESOURCE_BUTTON    = "Share Your Resource"
  LINK_SHARE_RESOURCE_MAIN      = "Share Resource"
  LINK_BROWSE_RESOURCE_MAIN     = "Browse"
  LINK_HOW_IT_WORKS             = "How It Works"
  LINK_MY_ACCOUNT               = "My Account"

  #IP Gateway
  MAX_USERS_MINUTES_WINDOW = 10 
  MAX_USERS_FROM_IP = 10 
end