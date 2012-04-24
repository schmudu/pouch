FactoryGirl.define do
  factory :user do
    #screen_name                   "Test User"
    email                  "user@example.com"
    password               "password"
    password_confirmation  "password"
    screen_name "John"
    admin false
  end
end