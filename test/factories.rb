FactoryGirl.define do
  factory :user do
    #screen_name                   "Test User"
    email                  "user@example.com"
    password               "aaaAAA6"
    password_confirmation  "aaaAAA6"
    screen_name "John"
    admin false
  end

  factory :resource do
    description         "some random description"
    title               "worksheet of fractions"
    #user_id needs to be provided
  end
end