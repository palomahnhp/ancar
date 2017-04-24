class Supervisor::ProcessSummaryController < Supervisor::BaseController
  before_action :require_user, only: [:index, :show]

  def index
    @organization_type = OrganizationType.where(description: 'Distritos').first
    @period = @organization_type.periods.last
    @type = params[:type] if params[:type]
    @main_processes = main_process_by_order  # main_processes_select_options

    unless params[:main_process_id].nil?
      @main_process = MainProcess.find(params[:main_process_id])
      @indicator_metrics = get_total_indicators
    end

    if @type and @type == 'SubProcess'
      @mp_id = params[:id] if params[:id]
      if @mp_id
        @sub_processes = sub_process_by_order  # main_processes_select_options
      end
    end
  end

private
  def main_processes_select_options
    MainProcess.where(period_id: @period.id).collect { |v| [ v.item.description, v.id ] }
  end

  def main_process_by_order
    MainProcess.all.order(:order)
  end

  def sub_process_by_order
    MainProcess.find(@mp_id).sub_processes.order(:order)
  end
end
