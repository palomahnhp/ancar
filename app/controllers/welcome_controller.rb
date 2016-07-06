class WelcomeController < ApplicationController
  after_action :require_user, only: [:index, :show]
  before_action :check_session

  def index
  end

private
  def check_session
    if params[:logout] == "true"
     session[:user_id] = nil
    end
  end
end
