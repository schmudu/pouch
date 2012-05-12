require 'spec_helper'

describe FirstUser do
  it "should be valid with an email" do
    first_user = FirstUser.new(:email => 'hello@abc.com')
    first_user.should be_valid
  end

  it "should not be valid with nil" do
    first_user = FirstUser.new(:email => nil)
    first_user.should_not be_valid
  end

  it "should not be valid with an empty string" do
    first_user = FirstUser.new(:email => '')
    first_user.should_not be_valid
  end

  it "should not be valid with an empty string" do
    first_user = FirstUser.create(:email => 'abc@abc.com')
    second_user = FirstUser.new(:email => 'abc@abc.com')
    second_user.should_not be_valid
  end
end
