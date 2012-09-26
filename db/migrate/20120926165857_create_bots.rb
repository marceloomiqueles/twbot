class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.string :nombre
      t.string :tw_cuenta
      t.string :tw_token
      t.string :tw_secret
      t.integer :estado

      t.timestamps
    end
  end
end
