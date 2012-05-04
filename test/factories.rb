include ActionDispatch::TestProcess
include ConstantsHelper

FactoryGirl.define do
  factory :user do
    email                  "user@example.com"
    password               "aaaAAA6"
    password_confirmation  "aaaAAA6"
    screen_name            "John"
    admin                  false
  end

  factory :resource do
    description         "some random description"
    title               "worksheet of fractions"
    #user_id needs to be provided
  end

  factory :attachment do
    download_count      0
    #file                File.open(File.join(Rails.root, '/public/robots.txt'))
    #file                fixture_file_upload((File.join(Rails.root, '/public/robots.txt')), 'txt')
    #file                Rack::Test::UploadedFile.new((File.join(Rails.root, '/public/robots.txt')), 'txt')
    file                Rack::Test::UploadedFile.new(TEST_FILE_PATH, 'txt')
  end
end