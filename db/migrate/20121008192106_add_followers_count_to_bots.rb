class AddFollowersCountToBots < ActiveRecord::Migration
  def change
    add_column :bots, :followers_count, :integer
  end
end
