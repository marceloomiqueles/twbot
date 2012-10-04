class AddVerificarSeguidoToBots < ActiveRecord::Migration
  def change
    add_column :bots, :verificar_seguido, :integer
  end
end
