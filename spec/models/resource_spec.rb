require 'spec_helper'

describe Resource do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
  end

  describe "title" do
    it "should be invalid with no description" do 
      Resource.any_instance.stub_chain(:attachments, :empty?).and_return(false)
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :title => nil)
      resource.should_not be_valid
    end
  end

  describe "description" do
    it "should be invalid with no description" do 
      Resource.any_instance.stub_chain(:attachments, :empty?).and_return(false)
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :description => nil)
      resource.should_not be_valid
    end
  end

  describe "user id" do
    it "should be valid with user id submitted" do 
      Resource.any_instance.stub_chain(:attachments, :empty?).and_return(false)
      resource = FactoryGirl.build(:resource, :user_id => @user.id)
      resource.should be_valid
    end

    it "should be invalid with user id as nil" do 
      Resource.any_instance.stub_chain(:attachments, :empty?).and_return(false)
      resource = FactoryGirl.build(:resource, :user_id => nil)
      resource.should_not be_valid
    end
  end

  describe "attachments" do
    it "should be valid if attachments is set" do
      Resource.any_instance.stub_chain(:attachments, :empty?).and_return(false)
      resource = FactoryGirl.create(:resource, :user_id => @user.id)
      #attachment = FactoryGirl.create(:attachment, :attachable_id => resource.id, :attachable_type => 'Resource')
      resource.should be_valid
    end

    it "should be invalid if attachments is empty" do
      resource = FactoryGirl.build(:resource, :user_id => @user.id)
      resource.should_not be_valid
    end
  end
end
