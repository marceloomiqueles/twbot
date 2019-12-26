class AddSiguiendoSeguidoresToBots < ActiveRecord::Migration
  def change
    add_column :bots, :siguiendo, :integer
    add_column :bots, :seguidores, :integer
  end
end
