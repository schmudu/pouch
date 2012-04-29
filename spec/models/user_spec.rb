require 'spec_helper'

describe User do
  describe "status" do
    it "should respond to status" do
      #user = FactoryGirl.build(:user, :password => 'aaaAAA7', :password_confirmation => 'aaaAAA7')
      user = FactoryGirl.build(:user)
      user.status.should == 0
    end
  end

  describe "screen name" do
    it "should be valid with no changes" do 
      user = FactoryGirl.build(:user)
      user.should be_valid
    end

    it "should not be valid with a password of only upper case letters" do 
      user = FactoryGirl.build(:user, :password => 'A'*6, :password_confirmation => 'A'*6)
      user.should_not be_valid
    end

    it "should not be valid with a password of only lower case letters" do 
      user = FactoryGirl.build(:user, :password => 'a'*6, :password_confirmation => 'a'*6)
      user.should_not be_valid
    end

    it "should not be valid with a password of only lower and upper case letters" do 
      user = FactoryGirl.build(:user, :password => 'aaaAAA', :password_confirmation => 'aaaAAA')
      user.should_not be_valid
    end

    it "should be valid with a password of lower and upper case letters and a number" do 
      user = FactoryGirl.build(:user, :password => 'aaaAAA6', :password_confirmation => 'aaaAAA6')
      user.should be_valid
    end

    it "should not allow duplicate screen names" do
      FactoryGirl.create(:user, :screen_name => 'some_name', :email => 'lksdjf@lkdfj.com')
      user = FactoryGirl.build(:user, :screen_name => 'some_name', :email => 'kjkkjkf@lkdfj.com')
      user.should_not be_valid
    end
  end

  describe "created_ip" do
    it "should respond to created_ip" do
      user = FactoryGirl.build(:user)
      user.should respond_to(:created_ip)
    end

    it "should not allow more than #{ConstantsHelper::MAX_USERS_FROM_IP} users to be created from one ip address under #{ConstantsHelper::MAX_USERS_MINUTES_WINDOW} minutes" do
      ConstantsHelper::MAX_USERS_FROM_IP.times do |n|
        user = FactoryGirl.create(:user, :email => "email#{n}@abc.com", :screen_name => "screen_name#{n}", :password => 'aaaAAA6', :password_confirmation => 'aaaAAA6')
      end
      user = FactoryGirl.build(:user, :email => "email@abc.com", :screen_name => "screen_name", :password => 'aaaAAA6', :password_confirmation => 'aaaAAA6')
      user.should_not be_valid
    end
  end

  describe "resources" do
    it "should respond to resources" do
      user = FactoryGirl.create(:user)
      user.should respond_to(:resources)
    end

    it "should respond to resources" do
      user = FactoryGirl.create(:user)
      lambda do
        resource = FactoryGirl.create(:resource, :user_id => user.id)
      end.should change(user.resources, :count).from(0).to(1)
    end
  end
end
