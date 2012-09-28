class CreateBotCiudades < ActiveRecord::Migration
  def change
    create_table :bot_ciudades do |t|
      t.integer :bot_id
      t.integer :ciudad_id

      t.timestamps
    end
  end
end
