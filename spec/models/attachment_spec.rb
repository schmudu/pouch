require 'spec_helper'

describe Attachment do
  include ConstantsHelper

  it "should be valid form factory" do
    attachment = FactoryGirl.build(:attachment)
    attachment.should be_valid
  end

  describe "file" do
    it "should invalid if file is nil" do 
      attachment = FactoryGirl.build(:attachment, :file => nil)
      attachment.should_not be_valid
    end

    it "should valid if file is not nil" do 
      attachment = FactoryGirl.build(:attachment, :file => nil)
      attachment.file = FileUploader.new(attachment, :file)
      attachment.file.store!(File.open(TEST_FILE_PATH))
      attachment.should be_valid
    end
  end

  describe "download count" do
    it "should response to download count" do 
      attachment = FactoryGirl.build(:attachment)
      attachment.should respond_to(:download_count)
    end
  end
end
