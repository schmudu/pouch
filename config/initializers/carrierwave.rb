if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAJO3MLJ76L33TIIQA',       # required
      :aws_secret_access_key  => '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',       # required
      :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = 'lessonpouch'                               # required
    #config.fog_host      = 'https://assets.example.com'            # optional, defaults to nil
    config.fog_public     = false                                   # optional, defaults to true
    config.storage        = :fog
    #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end