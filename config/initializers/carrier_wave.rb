if Rails.env.production?
	CarrierWave.configure do |config|
		 config.fog_credentials = {
		provider: 'AWS',
    access_key_id:     ENV['aws_access_key_id'],
    secret_access_key: ENV['aws_secret_access_key'],
    region:            "us-east-1"
  	}

		config.fog_directory= ENV['S3_BUCKET']
	end
end