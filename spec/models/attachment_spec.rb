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

  describe "downloads" do
    it "should response to downloads" do 
      attachment = FactoryGirl.build(:attachment)
      attachment.should respond_to(:downloads)
    end
  end

  describe "user_attachment_downloads" do
    it "should response to user_attachment_downloads" do 
      attachment = FactoryGirl.build(:attachment)
      attachment.should respond_to(:user_attachment_downloads)
    end
  end
end
