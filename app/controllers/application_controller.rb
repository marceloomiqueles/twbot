class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :autentificacion, :except => :login

  # verifica autentificación
  def autentificacion
    if session[:login]
      if session[:last_seen] < 1.hour.ago
        reset_session
        render :template => 'bots/login'
      end
      session[:last_seen] = Time.now
    else
      render :template => 'bots/login'
    end
  end

  # Login
  def login
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:login] = user
      session[:last_seen] = Time.now
      redirect_to root_path
    else
      flash.now[:error] = 'Usuario o Password Incorrectos'
      render :template => 'bots/login'
    end
  end
end
