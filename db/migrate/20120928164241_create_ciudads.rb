class CreateCiudads < ActiveRecord::Migration
  def change
    create_table :ciudads do |t|
      t.string :nombre
      t.string :longitud
      t.string :latitud
      t.integer :km

      t.timestamps
    end
  end
end
