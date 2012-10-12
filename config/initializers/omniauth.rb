Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 'LHfqxDyR3X095UCMW3gJjA', 'bd8IPh4TLN8DXE7ic0p1IpeTjvPeO6OxCDNu7MnKFg'  
  # Added to config/initializers/omniauth.rb
	OmniAuth.config.on_failure = Proc.new { |env|
	  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
	}
end
