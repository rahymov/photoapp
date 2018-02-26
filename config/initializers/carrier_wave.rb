if Rails.env.production?
	CarrierWave.configure do |config|
		 config.aws_credentials = {
    access_key_id:     ENV['aws_access_key'],
    secret_access_key: ENV['aws_secret_access_key'],
  	}

		config.fog_directory= ENV['S3_BUCKET']
	end
end