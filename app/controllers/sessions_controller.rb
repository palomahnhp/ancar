require 'uweb_authenticator'
class SessionsController < ApplicationController

  def create
    destroy_session
    if authenticated_uweb?
      Rails.logger.info { "  INFO - SessionController#create: Sesión creada - #{params}" }
      redirect_to root_path
    else
      Rails.logger.error { "  ERROR - SessionControler#create: Sesión ERROR - #{params}" }
      redirect_to root_path, notice: 'Usuario no autorizado'
    end
  end

  def destroy
    current_user.login
    destroy_session
    redirect_to root_path, notice: 'Se ha cerrado la sesión: usuario desconectado'
  end

  private
    def destroy_session
      session[:user_id] = nil
    end

    def authenticated_uweb?
      if Setting['user_test'] == params[:user_test]
        user = User.find_by_login(params[:login])
        if user
          session[:user_id] = user.id
          Rails.logger.info { "  INFO - SessionControler#authenticated_uweb? Validación Uweb correcta para - #{user.login}" }
          return true
        else
          Rails.logger.error { "  ERROR - SessionControler#authenticated_uweb? Usuario en LOCAL no esta en User - #{params}" }
          return false
        end
      end
      if uw_user = UwebAuthenticator.new(params).auth
        user = User.find_or_create_by(login: uw_user[:login])
        if user.uweb_update!(uw_user)
          session[:user_id] = user.id
          Rails.logger.info { "  INFO - SessionControler#authenticated_uweb? Validación Uweb correcta para - #{user.login}" }
          return true
        else
          Rails.logger.error { "  ERROR - SessionControler#user.uweb_update! Falla actualización user con datos Uweb - #{params}" }
          return false
        end
      else
        return false
      end
    end
end
