# Controlador base de la aplicacion
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # GET /home
  #
  # muestra la pagina principal
  def home
    render '/home'
  end
end
