class Bot < ActiveRecord::Base
  attr_accessible :estado, :nombre, :tw_cuenta, :tw_secret, :tw_token, :siguiendo, :seguidores
  has_many :palabras
  has_many :botCiudads
end
