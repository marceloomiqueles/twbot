Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, ENV['TW_CONSUMER_KEY'], ENV['TW_CONSUMER_SECRET']
  # Added to config/initializers/omniauth.rb
	OmniAuth.config.on_failure = Proc.new { |env|
	  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
	}
end
