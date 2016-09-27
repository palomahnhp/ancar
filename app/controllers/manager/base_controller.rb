class Manager::BaseController < ApplicationController
  layout 'admin'

  private

    def verify_manager
#      raise CanCan::AccessDenied unless current_user.try(:manager?)
    end
end
