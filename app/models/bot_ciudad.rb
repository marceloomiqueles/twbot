class BotCiudad < ActiveRecord::Base
  attr_accessible :bot_id, :ciudad_id
  belongs_to :bot
  belongs_to :ciudad
end
