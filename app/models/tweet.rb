class Tweet < ActiveRecord::Base
  attr_accessible :bot_id, :estado, :tw_created_at, :tw_location, :tw_text, :tw_tweet_id, :tw_usuario, :tw_usuario_id, :created_at
  belongs_to :bot
end
