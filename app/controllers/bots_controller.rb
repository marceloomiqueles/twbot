class BotsController < ApplicationController
  def index
  	@bots = Bot.all
  end

  def nuevo
  	@bot = Bot.new
  end

  def editar
  end

  def agregar_palabras
  end
end
