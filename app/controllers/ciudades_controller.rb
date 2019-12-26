class CiudadesController < ApplicationController
  before_action :recuperar_ciudad, :only => [:editar, :actualizar, :eliminar]

  def recuperar_ciudad
    @ciudad = Ciudad.find(params[:id])
  end

  def index
    @ciudades = Ciudad.all
  end

  def nueva
    @ciudad = Ciudad.new
  end

  def guardar
    @ciudad = Ciudad.new(ciudad_params)
    if @ciudad.valid?
      @ciudad.save
      redirect_to(ciudades_path, :notice => "Nueva Ciudad Agregada")
    else
      flash[:error] = "Error en los datos ingresados"
      render 'nueva'
    end
  end

  def editar
  end

  def actualizar
    if @ciudad.update_attributes(ciudad_params)
      redirect_to(ciudades_path, :notice => "Ciudad Actualizada")
    else
      flash[:error] = "Error en los datos ingresados"
      render 'edit'
    end
  end

  def eliminar
    @ciudad.destroy
    redirect_to(ciudades_path, :notice => "Ciudad Eliminada")
  end
  
  private
    def ciudad_params
      params.require(:ciudad).permit(:nombre, :longitud, :latitud, :km)
    end
end
