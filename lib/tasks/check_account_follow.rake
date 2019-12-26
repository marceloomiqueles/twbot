require 'twitter'

task :check_account_follow => :environment do
	bots = Bot.all.where(:estado => 1)
	puts "Bots Count: #{bots.count}"
	if bots.count > 0
		bots.each do |bot|
			registers = FollowRegister.all.where("estado_id = 1 and tw_bot = #{bot.id_bot}")
			puts "Registers Count: #{registers.count}"
			if registers.count > 0
				registers.each do |register|
					@twitter = Twitter::REST::Client.new do |config|
						config.consumer_key         = ENV['TW_CONSUMER_KEY']
						config.consumer_secret      = ENV['TW_CONSUMER_SECRET']
						config.access_token         = bot.tw_token
						config.access_token_secret  = bot.tw_secret
					end

					followers = @twitter.follower_ids(:count => 20)
					followers.each do |follower|
						verify_follower = TwCuenta.select(:id).where(:id_bot => follower)
						verify_rel     = TwFollower.select(:id).where(:tw_user_id => register.tw_follow).where(:tw_follower => follower)
						if verify_follower.count == 0
							@tw_cuenta = TwCuenta.new(:id_bot => follower)
							if @tw_cuenta.save 
								puts "Nueva cuenta ID: #{follower}"
							end
						else
							puts "Cuenta ya existe: #{follower}"
						end
						if verify_rel.count == 0
							@tw_follow = TwFollower.new(:tw_user_id => register.tw_follow, :tw_follower => follower)
							if @tw_follow.save 
								puts "Nuevo Follow: #{follower} a #{register.tw_follow}"							
							end
						else
							puts "Follow ya existe!"
						end
					end

					begin
						friends = @twitter.friend_ids(register.tw_follow).take(100)
						puts "Cantidad followers: #{friends.count}"
					rescue Twitter::Error::TooManyRequests => error
					  # NOTE: Your process could go to sleep for up to 15 minutes but if you
					  # retry any sooner, it will almost certainly fail with the same exception.
					  puts "Esperar #{error.rate_limit.reset_in} segundos"
					  sleep error.rate_limit.reset_in + 1
					  retry
					end
					friends.each do |friend|
						verify_friends = TwCuenta.select(:id).where(:id_bot => friend)
						verify_rel    = TwFriend.select(:id).where(:tw_user_id => register.tw_follow).where(:tw_friend => friend)
						if verify_friends.count == 0
							@tw_cuenta = TwCuenta.new(:id_bot => friend)
							if @tw_cuenta.save 
								puts "Nueva cuenta ID: #{friend}"
							end
						end
						if verify_rel.count == 0
							@tw_follow = TwFriend.new(:tw_user_id => register.tw_follow, :tw_friend => friend)
							if @tw_follow.save 
								puts "Nuevo Friend: #{friend} a #{register.tw_follow}"							
							end
						end
					end
				end
			end
		end
	end
end