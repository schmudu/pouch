require 'spec_helper'
#require 'support/fog_helper'
require 'carrierwave/test/matchers'

describe FileUploader do
  include CarrierWave::Test::Matchers

  # before(:each) do
  #   FileUploader.enable_processing = true
  #   @attachment = FactoryGirl.create(:attachment)
  #   @uploader = FileUploader.new(@attachment, :file)
  #   @uploader.store!(File.open(File.join(Rails.root, '/public/robots.txt')))
  # end

  # after do
  #   FileUploader.enable_processing = false
  #   @uploader.remove!
  # end
end
