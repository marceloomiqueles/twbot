class AddCantidadSeguirToBots < ActiveRecord::Migration
  def change
    add_column :bots, :cantidad_seguir, :integer
  end
end
