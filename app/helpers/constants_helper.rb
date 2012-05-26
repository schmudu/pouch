module ConstantsHelper
  #files
  FILE_EXTENSION_TXT            = 'txt'
  FILE_EXTENSION_RTF            = 'rtf'
  FILE_EXTENSION_PDF            = 'pdf'
  FILE_EXTENSION_DOC            = 'doc'
  FILE_EXTENSION_DOCX           = 'docx'

  #testing
  TEST_FILE_PATH                = File.join(Rails.root, '/test/downloads/sample_one.txt')
  
  #links
  #ip gateway
  MAX_USERS_MINUTES_WINDOW      = 10 
  MAX_USERS_FROM_IP             = 10 

  #resources
  RESOURCE_ATTACHMENTS_MIN_NUM  = 1
  RESOURCE_DESCRIPTION_MIN_LENGTH = 50;  #characters
end