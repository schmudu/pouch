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

  describe "topics" do
    it "should respond to resource_topics" do 
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :description => nil)
      resource.should respond_to(:topics)
    end
  end

  describe "resource_topics" do
    it "should respond to resource_topics" do 
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :description => nil)
      resource.should respond_to(:resource_topics)
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
    it "should have an attachment count of 2" do
      attachment_one = FactoryGirl.create(:attachment)
      attachment_two = FactoryGirl.create(:attachment)
      resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
      resource.should be_valid
      resource.attachments.length.should == 2
    end
  end

  describe "views" do
    it "should respond" do 
      resource = FactoryGirl.build(:resource, :user_id => @user.id)
      resource.should respond_to(:views)
    end
  end

  describe "extracted_content" do
    describe "with a pdf file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.pdf')), 'pdf'))
        @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])
      end

      it "should respond to extracted_content" do
        @resource.should respond_to(:extracted_content)
      end

      it "should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.pdf')), 'pdf'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.pdf')), 'pdf'))
        resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a txt file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])
      end

      it "extracted_content should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.txt')), 'txt'))
        resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a doc file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.doc')), 'doc'))
        @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])
      end

      it "extracted_content should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.doc')), 'doc'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.doc')), 'doc'))
        resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a docx file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.docx')), 'docx'))
        @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])
      end

      it "extracted_content should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.docx')), 'docx'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.docx')), 'docx'))
        resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end
  end
end
