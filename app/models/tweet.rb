class Tweet < ActiveRecord::Base
  belongs_to :bot, class_name: "Bot"
end
