class ProcessSummaryController < ApplicationController
  before_action :require_user, only: [:index, :show]

  def index
    @organization_type = OrganizationType.where(description: "Distritos").first
    @period = @organization_type.periods.last

    if params[:main_process_id].nil?
      @main_processes = main_process_by_order  # main_processes_select_options
    else
      @main_process = MainProcess.find(params[:main_process_id])
      @indicator_metrics = get_total_indicators
    end
  end

private
  def main_processes_select_options
    MainProcess.where(period_id: @period.id).collect { |v| [ v.item.description, v.id ] }
  end

  def main_process_by_order
    MainProcess.all.order(:order)
  end
end
