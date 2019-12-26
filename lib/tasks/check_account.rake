require 'twitter'

task :check_account => :environment do
	bots = Bot.all.where(:estado => 1)
	puts "Bots Count: #{bots.count}"
	if bots.count > 0
		bots.each do |bot|
			@twitter = Twitter::REST::Client.new do |config|
				config.consumer_key         = ENV['TW_CONSUMER_KEY']
				config.consumer_secret      = ENV['TW_CONSUMER_SECRET']
				config.access_token         = bot.tw_token
				config.access_token_secret  = bot.tw_secret
			end
			followers = @twitter.follower_ids(:count => 5000)
			followers.each do |follower|
				verify_follower = TwCuenta.select(:id).where(:id_bot => follower)
				verify_rel     = TwFollower.select(:id).where(:tw_user_id => bot.id_bot).where(:tw_follower => follower)
				if verify_follower.count == 0
					@tw_cuenta = TwCuenta.new(:id_bot => follower)
					if @tw_cuenta.save 
						puts "Nueva cuenta ID: #{follower}"
					end
				end
				if verify_rel.count == 0
					@tw_follow = TwFollower.new(:tw_user_id => bot.id_bot, :tw_follower => follower)
					if @tw_follow.save 
						puts "Nuevo Follow: #{follower} a #{bot.id_bot}"							
					end
				end
			end
			friends = @twitter.friend_ids(:count => 5000)
			friends.each do |friend|
				verify_friends = TwCuenta.select(:id).where(:id_bot => friend)
				verify_rel    = TwFriend.select(:id).where(:tw_user_id => bot.id_bot).where(:tw_friend => friend)
				if verify_friends.count == 0
					@tw_cuenta = TwCuenta.new(:id_bot => friend)
					if @tw_cuenta.save 
						puts "Nueva cuenta ID: #{friend}"
					end
				end
				if verify_rel.count == 0
					@tw_follow = TwFriend.new(:tw_user_id => bot.id_bot, :tw_friend => friend)
					if @tw_follow.save 
						puts "Nuevo Friend: #{friend} a #{bot.id_bot}"							
					end
				end
			end
		end
	end
end