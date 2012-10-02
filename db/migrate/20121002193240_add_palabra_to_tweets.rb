class AddPalabraToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :palabra, :string
  end
end
