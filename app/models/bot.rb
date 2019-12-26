class Bot < ActiveRecord::Base
  has_many :palabras
  has_many :botCiudads
  has_many :tweets, class_name: "Tweet", foreign_key: "bot_id"

end
