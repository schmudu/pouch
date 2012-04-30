require 'spec_helper'
#require 'support/fog_helper'
require 'carrierwave/test/matchers'

describe FileUploader do
  include CarrierWave::Test::Matchers

  before(:each) do
    @attachment = FactoryGirl.create(:attachment)
    @uploader = FileUploader.new(@attachment, :file)
    @uploader.store!(File.open(File.join(Rails.root, '/public/robots.txt')))
  end

  it "should increment download count by 1" do 
    lambda do
      @uploader.retrieve_from_store!(@uploader.file.url)
    end.should change(@attachment, :download_count).from(0).to(1)
  end
end
