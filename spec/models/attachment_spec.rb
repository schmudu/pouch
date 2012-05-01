require 'spec_helper'

describe Attachment do
  it "should be valid form factory" do
    attachment = FactoryGirl.build(:attachment)
    attachment.should be_valid
  end

  describe "download count" do
    it "should response to download count" do 
      attachment = FactoryGirl.build(:attachment)
      attachment.should respond_to(:download_count)
    end

  end
end
