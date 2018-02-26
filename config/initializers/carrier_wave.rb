
CarrierWave.configure do |config|
	if Rails.env.development?
    config.storage = :file
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :fog
		config.fog_credentials = {
		provider: 'AWS',
    aws_access_key_id:     ENV['S3_ACCESS_KEY'],
    aws_secret_access_key: ENV['S3_SECRET_KEY'],
    region:            "us-east-1"
  	}
		config.fog_directory= ENV['S3_BUCKET']
	end
end