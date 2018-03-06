class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :verify_administrator

  private

    def verify_administrator
      raise CanCan::AccessDenied unless current_user.has_role? :admin
    end
end
