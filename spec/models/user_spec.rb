require 'spec_helper'

describe User do
  describe "screen name" do
    it "should be valid with no changes" do 
      user = FactoryGirl.build(:user, :password => 'aaaAAA7', :password_confirmation => 'aaaAAA7')
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
  end
end
