class Palabra < ActiveRecord::Base
  attr_accessible :bot_id, :palabra
  belongs_to :bot
end
