class CreateFollowRegisters < ActiveRecord::Migration
  def change
    create_table :follow_registers do |t|
      t.integer :tw_bot
      t.integer :tw_follow
      t.integer :estado_id, :default => 1

      t.timestamps null: false
    end
  end
end
