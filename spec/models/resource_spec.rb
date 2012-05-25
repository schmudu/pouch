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
        #@resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one]
        @resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [@attachment_one])
        @resource.extract_content
        @resource.save
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
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        
        #text from file one
        puts "content: #{resource.extracted_content} match:#{resource.extracted_content.index('first')}"
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a rtf file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.rtf')), 'rtf'))
        #@resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])
        @resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [@attachment_one]) 
        @resource.extract_content
        @resource.save
      end

      it "extracted_content should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.rtf')), 'rtf'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.rtf')), 'rtf'))
        #resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])  
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])  
        resource.extract_content
        resource.save

        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a txt file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        @resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [@attachment_one])
        @resource.extract_content
        @resource.save
      end

      it "extracted_content should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        #attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        #attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.txt')), 'txt'))
        attachment_one = FactoryGirl.create(:attachment, :file_cache => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'), :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
  puts ("====created attachment: cache: #{attachment_one.file_cache}\n")
        attachment_two = FactoryGirl.create(:attachment, :file_cache => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.txt')), 'txt'), :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.txt')), 'txt'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two]) 
        resource.extract_content
        resource.save
        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a doc file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.doc')), 'doc'))
        @resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [@attachment_one])
        @resource.extract_content
        @resource.save
      end

      it "extracted_content should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.doc')), 'doc'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.doc')), 'doc'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a docx file" do
      before(:each) do
        @attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.docx')), 'docx'))
        @resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [@attachment_one])
        @resource.extract_content
        @resource.save
      end

      it "extracted_content should not be nil" do
        @resource.extracted_content.should_not be_nil
      end

      it "should append all the content into extracted content if multiple files are submitted" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.docx')), 'docx'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.docx')), 'docx'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        #text from file one
        resource.extracted_content.should match /first/

        #text from file two
        resource.extracted_content.should match /second/
      end
    end

    describe "with a mix of file atttachments" do
      it "one txt and one pdf" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.pdf')), 'pdf'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /txt/
        resource.extracted_content.should match /pdf/
      end
      
      it "one txt and one doc" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.doc')), 'doc'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /txt/
        resource.extracted_content.should match /doc/
      end
      
      it "one txt and one docx" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.docx')), 'docx'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /txt/
        resource.extracted_content.should match /docx/
      end
      
      it "one txt and one rtf" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.txt')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.rtf')), 'rtf'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /txt/
        resource.extracted_content.should match /rtf/
      end

      it "one rtf and one pdf" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.rtf')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.pdf')), 'pdf'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /rtf/
        resource.extracted_content.should match /pdf/
      end

      it "one rtf and one doc" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.rtf')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.doc')), 'doc'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /rtf/
        resource.extracted_content.should match /doc/
      end

      it "one rtf and one docx" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.rtf')), 'txt'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.docx')), 'docx'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /rtf/
        resource.extracted_content.should match /docx/
      end

      it "one pdf and one doc" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.pdf')), 'pdf'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.doc')), 'doc'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /pdf/
        resource.extracted_content.should match /doc/
      end

      it "one pdf and one docx" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.pdf')), 'pdf'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.docx')), 'docx'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /pdf/
        resource.extracted_content.should match /docx/
      end

      it "one doc and one docx" do
        attachment_one = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_one.doc')), 'doc'))
        attachment_two = FactoryGirl.create(:attachment, :file => Rack::Test::UploadedFile.new((File.join(Rails.root, '/test/downloads/sample_two.docx')), 'docx'))
        resource = FactoryGirl.build(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
        resource.extract_content
        resource.save
        resource.extracted_content.should match /doc/
        resource.extracted_content.should match /docx/
      end
    end
  end
end
