require 'spec_helper'

describe ResourceGrade do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    attachment_one = FactoryGirl.create(:attachment)
    attachment_two = FactoryGirl.create(:attachment)
    @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
    @grade = FactoryGirl.create(:grade)
  end

  it "should be valid" do
    resource_grade = ResourceGrade.new(:resource_id => @resource.id, :grade_id => @grade.id)
    resource_grade.should be_valid
  end

  it "should not be valid with resource_id as nil" do
    resource_grade = ResourceGrade.new(:resource_id => nil, :grade_id => @grade.id)
    resource_grade.should_not be_valid
  end

  it "should not be valid with resource_id as nil" do
    resource_grade = ResourceGrade.new(:resource_id => @resource.id, :grade_id => nil)
    resource_grade.should_not be_valid
  end

  it "should not be valid with duplicate attributes" do
    resource_grade = ResourceGrade.create(:resource_id => @resource.id, :grade_id => @grade.id)
    resource_grade_duplicate = ResourceGrade.create(:resource_id => @resource.id, :grade_id => @grade.id)
    resource_grade_duplicate.should_not be_valid
  end
end
