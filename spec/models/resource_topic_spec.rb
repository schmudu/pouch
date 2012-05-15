require 'spec_helper'

describe ResourceTopic do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    attachment_one = FactoryGirl.create(:attachment)
    attachment_two = FactoryGirl.create(:attachment)
    @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
    @topic = FactoryGirl.create(:topic, :name => "Algebra")
  end

  it "should be valid" do
    resource_topic = ResourceTopic.new(:resource_id => @resource.id, :topic_id => @topic.id)
    resource_topic.should be_valid
  end

  it "should not be valid with resource_id as nil" do
    resource_topic = ResourceTopic.new(:resource_id => nil, :topic_id => @topic.id)
    resource_topic.should_not be_valid
  end

  it "should not be valid with resource_id as nil" do
    resource_topic = ResourceTopic.new(:resource_id => @resource.id, :topic_id => nil)
    resource_topic.should_not be_valid
  end

  it "should not be valid with duplicate attributes" do
    resource_topic = ResourceTopic.create(:resource_id => @resource.id, :topic_id => @topic.id)
    resource_topic_duplicate = ResourceTopic.create(:resource_id => @resource.id, :topic_id => @topic.id)
    resource_topic_duplicate.should_not be_valid
  end
end
