class CreateTwFriends < ActiveRecord::Migration
  def change
    create_table :tw_friends do |t|
      t.integer :tw_user_id
      t.integer :tw_folower
      t.integer :estado_id, :default => 0

      t.timestamps null: false
    end
  end
end
