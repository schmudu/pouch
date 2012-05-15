require 'spec_helper'

describe Topic do
  it "should be valid with just a name" do
    topic = Topic.new(:name => "Algebra")
    topic.should be_valid
  end

  it "should not be valid with duplicate name" do
    topic_one = Topic.create(:name => "Algebra")
    topic_two = Topic.new(:name => "Algebra")
    topic_two.should_not be_valid
  end

  it "should not be valid with name set to nil" do
    topic = Topic.new(:name => nil)
    topic.should_not be_valid
  end

  it "should not be valid with name set to empty" do
    topic = Topic.new(:name => '')
    topic.should_not be_valid
  end

  describe "resource_topics" do
    it "should respond to resource_topics" do 
      topic = Topic.new(:name => "Algebra")
      topic.should respond_to(:resource_topics)
    end
  end

  describe "resources" do
    it "should respond to resource_topics" do 
      topic = Topic.new(:name => "Algebra")
      topic.should respond_to(:resources)
    end
  end
end
