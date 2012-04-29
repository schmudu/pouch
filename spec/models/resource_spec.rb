require 'spec_helper'

describe Resource do
  it "should be valid with user id submitted" do 
    user = FactoryGirl.create(:user)
    resource = FactoryGirl.build(:resource, :user_id => user.id)
    resource.should be_valid
  end

  describe "user id" do
    it "should be invalid with user id as nil" do 
      resource = FactoryGirl.build(:resource, :user_id => nil)
      resource.should_not be_valid
    end
  end
end
