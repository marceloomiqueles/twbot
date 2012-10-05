class BotsController < ApplicationController
  before_filter :recuperar_bot, :only => [:editar, :actualizar, :bot_on, :bot_off, :palabras, :agregar_palabra, :eliminar, :guardar_palabra, :ciudades, :tweets, :unfollow, :follow]

  # Recupera bot según parametro de url
  def recuperar_bot
    @bot = Bot.find(params[:id])
  end

  # Despliega Listado todos los Bots
  def index
  	@bots = Bot.all
  end

  # Despliega Formulario para gregar nuevo Bot
  def nuevo
  end

  # Guarda el nuevo Bot en la base de datos
  def guardar
  	@bot = Bot.new(params[:bot])
  	@bot.estado = 0
    @bot.siguiendo = 0
    @bot.seguidores = 0
    @bot.palabra_indice = 1
    @bot.palabra_maximo = 1
    @bot.ciudad_indice = 1
  	if @bot.valid?
  		@bot.save
  		redirect_to(root_path, :notice => "Bot creado OK")
  	else
  		flash[:error] = "Los datos del BOT no son validos, intenta nuevamente"
		  render 'nuevo2'
  	end
  end

  # Obtiene autentificación de Twitter para el Bot
  def auth
  	#raise request.env["omniauth.auth"].to_yaml 
  	begin
	  	auth = request.env["omniauth.auth"]
	  	if auth['credentials']['token']
		  	@bot = Bot.new(nombre: auth['info']['name'], tw_cuenta: auth['info']['nickname'], tw_token: auth['credentials']['token'], tw_secret: auth['credentials']['secret'], estado: 0)
		  	render 'nuevo2'
		else
			flash[:error] = "Error al autorizar al bot, intentalo nuevamente"
			render 'nuevo'
		end
	rescue Exception
		flash[:error] = "Error al autorizar al bot, intentalo nuevamente"
		render 'nuevo'
	end
  end

  # En caso de fallar la autentificación, muestra error en pantalla
  def fail_auth
  	flash[:error] = "Error al autorizar al bot, intentalo nuevamente"
    render 'nuevo'
  end

  # Elimina Bot del Sistema
  def eliminar
    @bot.destroy
    redirect_to(root_path, :notice => "Bot Eliminado")
  end

  # Formulario Editar
  def editar
  end

  # Formulario Editar
  def actualizar
    if @bot.update_attributes(params[:bot])
      redirect_to(root_path, :notice => "Bot Actualizado")
    else
      render 'editar'
    end
  end

  # Encender bot
  def bot_on
    @bot.estado = 1
    @bot.save
    redirect_to(root_path, :notice => "Bot Encendido")
  end

  # Apagar bot
  def bot_off
    @bot.estado = 0
    @bot.save
    redirect_to(root_path, :notice => "Bot Apagado")
  end

  # Despliega listado de Palabras de un Bot
  def palabras
  end

  # Despliega Formulario para agregar Palabra a un Bot
  def agregar_palabra
    @palabra = @bot.palabras.new
  end

  # Guarda nueva Palabra a un Bot
  def guardar_palabra
    @palabra = @bot.palabras.new(params[:palabra])
    if @palabra.valid?
      @palabra.save
      redirect_to(bot_palabras_path(@bot), :notice => "Palabra Agregada")
    else
      flash[:error] = "Ingresa una palabra o frase valida"
      render 'agregar_palabra'
    end
  end

  # Elimina Palabra de un Bot
  def eliminar_palabra
    @palabra = Palabra.find(params[:palabra_id])
    @palabra.destroy
    bot = Bot.find(params[:id])
    if bot.palabras.length == 0
      bot.update_attributes(estado: 0)
    end
    redirect_to(bot_palabras_path(params[:id]), :notice => "Palabra Eliminada")
  end

  # Muestra las ciudades asociadas al bot y disponibles para modificación
  def ciudades
    @ciudades = Ciudad.all
  end

  # Agregar Ciudad al Bot
  def agregar_ciudad
    BotCiudad.create(bot_id: params[:id], ciudad_id: params[:id_ciudad])
    redirect_to(bot_ciudades_path(params[:id]), notice: "Ciudad Agregada")
  end

  # Eliminar Ciudad del Bot
  def eliminar_ciudad
    @botciudad = BotCiudad.find(params[:id_botciudad])
    @botciudad.destroy
    bot = Bot.find(params[:id])
    if bot.botCiudads.length == 0
      bot.update_attributes(estado: 0)
    end
    redirect_to(bot_ciudades_path(params[:id]), notice: "Ciudad Eliminada")
  end

  # Mustra listado de las personas que se han seguido
  def tweets
  end

  # unfollow a personas manualmente
  def unfollow
    @twitter = Twitter::Client.new(
      :oauth_token => @bot.tw_token,
      :oauth_token_secret => @bot.tw_secret
    )

    @tweet = Tweet.find(params[:tweet])

    @twitter.unfollow(@tweet.tw_usuario)
    @tweet.estado = 4
    @tweet.save

    mensaje = "Dejo de seguir a " + @tweet.tw_usuario
    redirect_to(bot_tweets_path(@bot), notice: mensaje)
  end

  # follow a personas manualmente
  def follow
    @twitter = Twitter::Client.new(
      :oauth_token => @bot.tw_token,
      :oauth_token_secret => @bot.tw_secret
    )

    @tweet = Tweet.find(params[:tweet])

    @twitter.follow(@tweet.tw_usuario)
    @tweet.estado = 1
    @tweet.save

    mensaje = "Se sigue a " + @tweet.tw_usuario
    redirect_to(bot_tweets_path(@bot), notice: mensaje)
  end
end
