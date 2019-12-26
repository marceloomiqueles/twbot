class AddManejaIndicesToBots < ActiveRecord::Migration
  def change
    add_column :bots, :palabra_indice, :integer
    add_column :bots, :palabra_maximo, :integer
    add_column :bots, :ciudad_indice, :integer
  end
end
