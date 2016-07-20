require "uweb_authenticator"
require 'logger'


class SessionsController < ApplicationController
  before_action :initialize_logger, only: [:create, :show]

  def create
    destroy_session
    if authenticated_uweb?
      @logger.info('SessionControler#create: ') { "Sesion creada - #{params}" }
      redirect_to root_path
    else
      @logger.error('SessionControler#create: ') { "Sesion ERROR - #{params}" }
      redirect_to root_path, notice: "Usuario no autorizado"
    end
  end

  def destroy
    current_user.login()
    destroy_session
    redirect_to root_path, notice: "Se ha cerrado la sesión: usuario desconectado"
  end

  private
    def destroy_session
      session[:user_id] = nil
    end

    def authenticated_uweb?
      if uw_user = UwebAuthenticator.new(params).auth
        user = User.find_or_create_by(login: uw_user[:login])
        if user.uweb_update!(uw_user)
          session[:user_id] = user.id
          return true
        else
          @logger.error('SessionControler#authenticated_uweb? ') { "Falla comprobación Uweb - #{params}" }
          return false
        end
      else
        @logger.error('SessionControler#authenticated_uweb? ') { "Falla comprobación Uweb - #{params}" }
         user = User.find_by_login(params[:login])
         if user
           session[:user_id] = user.id
           @logger.info('SessionControler#authenticated_uweb? ') { "Validación Uweb correcta para - #{user.login}" }
           return true
         else
          @logger.error('SessionControler#authenticated_uweb? ') { "No encontrado usuario en BD:Users " }
          return false
         end
      end
    end

   def initialize_logger
      @logger = Logger.new('session.log', 'weekly')
      @logger.level = Logger::INFO
    end

end
