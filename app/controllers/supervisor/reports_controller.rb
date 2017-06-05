class Supervisor::ReportsController < Supervisor::BaseController
  respond_to :html, :js
  before_action :set_period,  only: [:index, :show]

  def index

  end

  def select_period
    @organization_types = current_user.auth_organization_types
  end

  def show
    class_name = params[:type].to_s.camelize
    class_name = Object.const_get(class_name)
    @process = class_name.find(params[:process])
    respond_to do |format|
      format.js
    end
  end

  private
  def set_period
    @period = Period.find(params[:id])
  end
end
