require "uweb_authenticator"

class SessionsController < ApplicationController

  def create
    destroy_session
    if authenticated_uweb?
      redirect_to root_path
    else
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
        else
          redirect_to root_path, notice: "Se ha cerrado la sesión: usuario desconectado"
        end
      end
    end

end
