class BotCiudad < ActiveRecord::Base
  belongs_to :bot
  belongs_to :ciudad
end
