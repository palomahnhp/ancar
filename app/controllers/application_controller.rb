class ApplicationController < ActionController::Base
  include HasFilters
  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if params['login']
      user = User.find_by_login(params['login'].downcase)
      if user
        session[:user_id]  = user.id
      end
    end

    unless current_user
       if self.controller_name  !=  'welcome'
          redirect_to root_url, notice: t('application.require_user.no_connect')
       end
    end
#   redirect_to root_url unless current_user
  end

  def ini_logger
     logger_status ? Setting['logger:status'] : '0'
     if logger_status == 1
       @@my_logger ||=  Logger.new(Setting['logger_name'], Setting['logger_age'])
       @@logger.level = Setting['logger_level']
       true
     else
       false
     end
  end

  private
    def verify_user
      raise ActionController::RoutingError.new('Not Found') unless current_user.present?
    end
end
