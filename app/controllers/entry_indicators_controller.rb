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
          update_assigned_employess(key)
        when 'IndicatorMetric'
          update_entry_indicators(params[key])
        else
          flash[:error] = t('entry_indicators.updates.no_key')
        end
      end
      @input_error = validate_input
    end

    if @input_error || (params[:justification] != "" && AssignedEmployee.no_unit_justified(@unit.id, @period.id))
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

  def update_assigned_employess(process)
    params[process].each do |pr|
      grupos = pr[1]
      process_id = pr[0].to_i
      if process == "Unit"
        type = "UnitJustified"
      else
        type = process
      end
      grupos.keys.each do |grupo|
        quantity = grupos[grupo]
        official_group_id = OfficialGroup.find_by_name(grupo).id

        if quantity.empty?
          @employess_cumplimented = false
          AssignedEmployee.where(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: @period.id, unit_id: @unit.id).delete_all
        else
          ae = AssignedEmployee.find_or_create_by(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: @period.id, unit_id: @unit.id)
          ae.quantity = quantity
          ae.updated_by = current_user.login
          ae.justified_by = current_user.login
          ae.justified_at = Time.now
          ae.justification = params[:justification] unless params[:justification].empty?
          ae.save
        end
      end
    end
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

  def all_cumplimented?
      @entry_indicators_cumplimented && @employess_cumplimented
  end

  def validate_in_out_stock
    errors_in_out_stock = Hash.new
    @period.main_processes.each do |main_process|
      main_process.sub_processes.each do |sub_process|
        stock = sub_process.get_stock(@unit_id)
        unless stock == 0
          in_amount = sub_process.get_amount('in', @unit_id)
          out_amount = sub_process.get_amount('out', @unit_id)
          errors_in_out_stock[sub_process.id] = [out_amount, in_amount, stock]  if out_amount > stock + in_amount
        end
      end
    end
    return errors_in_out_stock
  end

  def validate_input
    @errors_in_out_stock = validate_in_out_stock # por subproceso de la unidad
    @groups_excedeed = AssignedEmployee.exceeded_staff_for_unit(@unit.id, @period.id)
    @entry_incomplete = !(@entry_indicators_cumplimented && @employess_cumplimented)
    @entry_without_staff = validate_staff_for_entry
    return @groups_excedeed.present? || @entry_incomplete || @errors_in_out_stock.present? || @entry_without_staff.present?
  end

  def validate_staff_for_entry
    entry_without_staff = Hash.new
    @period.main_processes.each do |main_process|
      main_process.sub_processes.each do |sub_process|
        staff_quantity = indicator_amount = 0
        sub_process.tasks.each do |task|
          task.indicators.each do |indicator|
            indicator_amount   = indicator.amount(@unit.id)
            staff_quantity     = AssignedEmployee.staff_quantity(indicator, @unit.id)
            entry_without_staff[sub_process.id][indicator.id] = [indicator_amount, staff_quantity] if staff_quantity == 0 && indicator_amount > 0
          end
        end
      end
    end
    return entry_without_staff
  end
end



