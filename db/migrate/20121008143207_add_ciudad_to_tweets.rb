class AddCiudadToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :ciudad, :string
  end
end
