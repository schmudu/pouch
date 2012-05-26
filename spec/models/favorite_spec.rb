require 'spec_helper'

describe Favorite do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!

    @attachment_one = FactoryGirl.create(:attachment)
    @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])

    @another_resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])
  end

  describe "should be valid" do
    it "should be valid with regular user and resource" do
      @favorite = FactoryGirl.build(:favorite, :user_id => @user.id, :resource_id => @resource.id)
      @favorite.should be_valid
    end

    it "when user attempts to add the another favorite" do
      @favorite = FactoryGirl.create(:favorite, :user_id => @user.id, :resource_id => @resource.id)
      @another_favorite = FactoryGirl.create(:favorite, :user_id => @user.id, :resource_id => @another_resource.id)
      @another_favorite.should be_valid
    end
  end
  describe "should not be valid" do
    it "when user_id is nil" do
      @favorite = FactoryGirl.build(:favorite, :user_id => nil, :resource_id => @resource.id)
      @favorite.should_not be_valid
    end

    it "when user_id is set to a non-existent number" do
      @favorite = FactoryGirl.build(:favorite, :user_id => -9999, :resource_id => @resource.id)
      @favorite.should_not be_valid
    end

    it "when resource_id is set to a non-existent number" do
      @favorite = FactoryGirl.build(:favorite, :user_id => @user.id, :resource_id => -9999)
      @favorite.should_not be_valid
    end

    it "when resource_id is nil" do
      @favorite = FactoryGirl.build(:favorite, :user_id => @user.id, :resource_id => nil)
      @favorite.should_not be_valid
    end

    it "when user attempts to add the same resource twice as a favorite" do
      @favorite = FactoryGirl.create(:favorite, :user_id => @user.id, :resource_id => @resource.id)
      @another_favorite = FactoryGirl.build(:favorite, :user_id => @user.id, :resource_id => @resource.id)
      @another_favorite.should_not be_valid
    end
  end
end
