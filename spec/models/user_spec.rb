require 'spec_helper'

describe User do
  describe "screen name" do
    it "should be valid with no changes" do 
      user = FactoryGirl.build(:user)
      user.should be_valid
    end

    it "should not be valid with a simple password" do 
      user = FactoryGirl.build(:user, :password => 'a'*6, :password_confirmation => 'a'*6)
      user.should_not be_valid
    end
  end
end
