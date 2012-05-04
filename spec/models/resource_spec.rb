require 'spec_helper'

describe Resource do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
  end

  describe "title" do
    it "should be invalid with no description" do 
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :title => nil)
      resource.should_not be_valid
    end
  end

  describe "description" do
    it "should be invalid with no description" do 
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :description => nil)
      resource.should_not be_valid
    end
  end

  describe "user id" do
    it "should be valid with user id submitted" do 
      resource = FactoryGirl.build(:resource, :user_id => @user.id)
      resource.should be_valid
    end

    it "should be invalid with user id as nil" do 
      resource = FactoryGirl.build(:resource, :user_id => nil)
      resource.should_not be_valid
    end
  end

  describe "attachments" do
    it "should be valid if attachments is empty" do
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [])
      resource.should_not be_valid
    end

    it "should have an attachment count of 2" do
      attachment_one = FactoryGirl.create(:attachment)
      attachment_two = FactoryGirl.create(:attachment)
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
      resource.should be_valid
      resource.attachments.length.should == 2
    end

    it "should have an attachment count of 2 if the attachments is nil" do
      attachment_one = FactoryGirl.build(:attachment)
      attachment_two = FactoryGirl.build(:attachment, :file => nil)
      attachment_three = FactoryGirl.build(:attachment, :file => nil)
      attachment_four = FactoryGirl.build(:attachment, :file => nil)
      attachment_five = FactoryGirl.build(:attachment)
      resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two, attachment_three, attachment_four, attachment_five])
      resource.attachments.length.should == 2
    end
  end
end
