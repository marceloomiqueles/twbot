require 'twitter'

task :unfollow => :environment do
	15.times do
		bots = Bot.all.where(:estado => 1)
		puts "Bots Count: #{bots.count}"
		if bots.count > 0
			bots.each do |bot|
				# @unfollow_friends = TwFriend.select(:id, :tw_friend).where("tw_user_id = #{bot.id_bot} and tw_friends.estado_id = 0").limit(1000 / 24 / 4)
				@unfollow_friends = TwFriend.select(:id, :tw_friend).where("tw_user_id = #{bot.id_bot} and tw_friends.estado_id = 0").limit(99)
				puts "Query Count: #{@unfollow_friends.count}"
				if @unfollow_friends.count > 0
					@query_twitter = @unfollow_friends.map(&:tw_friend).join(',')
					@twitter = Twitter::REST::Client.new do |config|
						config.consumer_key         = ENV['TW_CONSUMER_KEY']
						config.consumer_secret      = ENV['TW_CONSUMER_SECRET']
						config.access_token         = bot.tw_token
						config.access_token_secret  = bot.tw_secret
					end
					@friendships = @twitter.friendships(@query_twitter, bot.id_bot)
					@friendships.each do |friendship|
						@friend_check = TwFriend.where("tw_user_id = #{bot.id_bot} and tw_friend = #{friendship.id}").first
						if ! @friend_check.nil?
							puts "Result: #{@friend_check.tw_friend} - Follow: #{friendship.connections.include? 'followed_by'}"
							if ! friendship.connections.include? 'followed_by'
								puts "Not Followed"
								if @twitter.unfollow(friendship.id)
									if @friend_check.update_attribute(:estado_id, 2)
										puts "Eliminado: #{friendship.id}"
									end
								else
									puts "Error id: @friend_check.id - #{friendship.id}"
								end
							elsif 
								puts "Followed"
								if @friend_check.update_attribute(:estado_id, 1)
									puts "Amigo Nuevo: #{friendship.id}"
								end
							end
						else
							puts "No Existe ID: #{bot.id_bot} - #{friendship.id}"
						end
					end
				end
			end
		end
	end
end