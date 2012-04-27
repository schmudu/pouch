FactoryGirl.define do
  factory :user do
    #screen_name                   "Test User"
    email                  "user@example.com"
    password               "aaaAAA6"
    password_confirmation  "aaaAAA6"
    screen_name "John"
    admin false
  end
end