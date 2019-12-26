require 'twitter'

task :follow => :environment do
	bots = Bot.all
	if bots.count > 0
		bots.each do |bot|
			tweets = bot.tweets.all.where("created_at <= '#{Time.now - bot.verificar_seguido.days}' AND estado = 0").limit(1000 / 24 / 4)
			puts "count: #{tweets.count}"
			if tweets.count
				@twitter = Twitter::REST::Client.new do |config|
					config.consumer_key         = ENV['TW_CONSUMER_KEY']
					config.consumer_secret      = ENV['TW_CONSUMER_SECRET']
					config.access_token         = bot.tw_token
					config.access_token_secret  = bot.tw_secret
				end
				tweets.each do |tweet|
					relacion = @twitter.friendship(tweet.tw_usuario_id.to_i, @twitter.user.id)
					if relacion.target.followed_by?
						tweet.update_attribute(:estado, 1)
						puts "Guardado: #{tweet.tw_usuario_id}"
					else
						if @twitter.unfollow(tweet.tw_usuario_id.to_i)
							tweet.update_attribute(:estado, 2)
							puts "Eliminado: #{tweet.tw_usuario_id}"
						else
							puts "Error id - #{tweet.tw_usuario_id}"
						end
					end
				end
			end
		end
	end
end