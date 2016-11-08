class Manager::BaseController < ApplicationController
  include ManagerActions
  layout 'admin'

  private

    def verify_manager
#      raise CanCan::AccessDenied unless current_user.try(:manager?)
    end
end
