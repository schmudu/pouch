require 'spec_helper'

describe UserResourceView do
  it "should be valid on factory create" do
    user_resource_view = FactoryGirl.create(:user_resource_view)
    user_resource_view.should be_valid
  end
end
