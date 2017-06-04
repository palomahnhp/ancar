class Supervisor::ReportsController < Supervisor::BaseController
  respond_to :html, :js
  before_action :set_period,  only: [:index, :show]

  def index

  end

  def select_period
    @organization_types = current_user.auth_organization_types
  end

  def show
    if params[:type] == :main_process
      @process = MainProcess.find(params[:main_process])
    end
    if params[:type] == :sub_process
      @process = SubProcess.find(params[:sub_process])
    end
    respond_to do |format|
      format.js
    end
  end

  private
  def set_period
    @period = Period.find(params[:id])
  end
end
