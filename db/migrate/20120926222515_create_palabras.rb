class CreatePalabras < ActiveRecord::Migration
  def change
    create_table :palabras do |t|
      t.integer :bot_id
      t.string :palabra

      t.timestamps
    end
  end
end
