class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if (params["login"])
      user = User.find_by_ayre(params["login"])
      if user
        session[:user_id]  = user.id
      end
    end

    if !current_user

       if self.controller_name  !=  'welcome'
          redirect_to root_url, notice: "Usuario no conectado"
       end
    end
#   redirect_to root_url unless current_user
  end
end
