class EntryIndicatorsController < ApplicationController
  before_action :require_user, only: [:index]
  before_action :initialize_instance_vars, only: [:index, :edit, :updates ]

  def index
    if @period.main_processes.empty?
      render :index, notice: t("entry_indicators.index.no_main_processes")
    end
  end

  def updates
    @entry_indicators_cumplimented = @employess_cumplimented = true
    unless params[:justification].present?
      params.keys.each do |key|
        case key
        when 'Indicator', 'Unit'
          @employess_cumplimented = AssignedEmployee.update(@period, @unit, key, params[key], current_user, params[:justification])
        when 'IndicatorMetric'
          update_entry_indicators(params[key])
        else
          flash[:error] = t('entry_indicators.updates.no_key')
        end
      end
      @input_error = validate_input
    end

    if @input_error || has_justification?
      render :index
    else
      flash[:notice] = t('entry_indicators.updates.success')
      redirect_to entry_indicators_path(unit_id: @unit.id, period_id: @period.id,
      organization_id: @organization.id)
    end
  end

  private

  def entry_indicator_params
      params.require(:entry_indicator).permit(:amount, :unit_id, :period_id, :indicator_metric, :indicator_source)
  end

  def initialize_instance_vars
    if params[:organization_id]
      @organization = Organization.find(params[:organization_id])
      @units = @organization.units.order(:order).to_a
    end
    if params[:period_id]
      @period = Period.includes(:assigned_employees, :entry_indicators, main_processes: [sub_processes: [tasks: [indicators:[
      indicator_metrics: [metric: [:item]],
      indicator_sources: [source: [:item]],
      total_indicators: [:summary_type] ]]]]).find(params[:period_id]) if params[:period_id]
    end
    if params[:unit_id]
      @unit = Unit.find(params[:unit_id])
    else
      @unit = @units.first
    end
  end

  def has_justification?
    (params[:justification] != "" && AssignedEmployee.no_unit_justified(@unit.id, @period.id))
  end

  def update_entry_indicators(indicator_metrics)
    Indicator.includes(indicator_metrics: [:entry_indicators, :total_indicators])
    indicator_metrics.each do |indicator|
      indicator[1].each do |im|
        indicator_metric_id = im[0].to_i
        amount = im[1]
        if amount.empty?
          @entry_indicators_cumplimented = false
          EntryIndicator.where(unit_id: @unit.id, indicator_metric_id: indicator_metric_id).delete_all
        else
          ei = EntryIndicator.find_or_create_by(unit_id: @unit.id, indicator_metric_id: indicator_metric_id)
#            ei.indicator_source_id = IndicatorSource.where(indicator_metric_id: indicator_metric_id).take.id
          ei.amount = amount
          ei.period_id = @period.id
          ei.updated_by = current_user.login
          ei.save
        end
      end
    end
  end

  def validate_input
    @errors_in_out_stock  = SubProcess.validate_in_out_stock(@period, @unit)
    @groups_excedeed      = AssignedEmployee.exceeded_staff_for_unit(@period, @unit)
    @entry_incomplete     = entry_incompleted?
    @entry_without_staff  = Indicator.validate_staff_for_entry(@period, @unit)
    return @groups_excedeed.present? || @entry_incomplete || @errors_in_out_stock.present? || @entry_without_staff.present?
  end

  def entry_incompleted?
      !(@entry_indicators_cumplimented && @employess_cumplimented)
  end

end



