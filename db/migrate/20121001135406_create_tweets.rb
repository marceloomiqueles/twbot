class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :bot_id
      t.string :tw_usuario_id
      t.string :tw_tweet_id
      t.string :tw_location
      t.string :tw_usuario
      t.string :tw_text
      t.string :tw_created_at
      t.integer :estado

      t.timestamps
    end
  end
end
