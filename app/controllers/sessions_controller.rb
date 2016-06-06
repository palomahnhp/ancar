class SessionsController < ApplicationController

  def create
    user = User.find_by_ayre(params[:session][:ayre])
    if user # && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_url
    else
      puts "Usuario no encontrado"
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
