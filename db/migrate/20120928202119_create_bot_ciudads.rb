class CreateBotCiudads < ActiveRecord::Migration
  def change
    create_table :bot_ciudads do |t|
      t.integer :bot_id
      t.integer :ciudad_id

      t.timestamps
    end
  end
end
