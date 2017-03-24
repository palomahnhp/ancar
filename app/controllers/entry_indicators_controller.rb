class EntryIndicatorsController < ApplicationController
  before_action :require_user, only: [:index]
  before_action :initialize_instance_vars, only: [:index, :edit, :updates ]

  def index
    if @period.main_processes.empty?
      render :index, notice: t("entry_indicators.index.no_main_processes")
    end
  end

  def updates
    if params[:justification].present?
      change_staff
    elsif params[:delete_justification].present?
      delete_change
    else
      update_entry
    end

    if @input_error || has_justification?
      render :index
    else
      flash[:notice] = t('entry_indicators.updates.success')
      redirect_to entry_indicators_path(unit_id: @unit.id, period_id: @period.id,
      organization_id: @organization.id)
    end
  end

  def change_staff
    AssignedEmployeesChange.update(@period, @unit, params[:justification], current_user)
  end

  def delete_change
    AssignedEmployeesChange.where(period: @period, unit: @unit).delete_all
  end

  def update_entry
    @entry_indicators_cumplimented = @employess_cumplimented = true
    if params[:change_staff]
      @change_staff = true
    else
      params.keys.each do |key|
        case key
            when 'Indicator', 'Unit'
              @employess_cumplimented = assigned_employees_update(key, params[key])
            when 'IndicatorMetric'
              @entry_indicators_cumplimented = update_indicator_metrics(params[key])
            else
              flash[:error] = t('entry_indicators.updates.no_key')
        end
      end
    end
    @input_error = validate_input
  end

  private
  def entry_indicator_params
    params.require(:entry_indicator).permit(:amount, :unit_id, :period_id, :indicator_metric, :indicator_source)
  end

  def update_indicator_metrics(indicator_metrics)
    Indicator.includes(indicator_metrics: [:entry_indicators, :total_indicators])
    indicator_metrics.each do |indicator|
      indicator[1].each do |im|
        indicator_metric_id = im[0].to_i
        amount = im[1]
        if amount.empty?
          EntryIndicator.where(unit_id: @unit.id, indicator_metric_id: indicator_metric_id).delete_all
          @entry_indicators_cumplimented = false
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
    return @entry_indicators_cumplimented
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
    (params[:justification] != ""  && AssignedEmployeesChange.unit_justified(@unit.id, @period.id))
  end

  def validate_input
    @errors_in_out_stock  = SubProcess.validate_in_out_stock(@period, @unit)  if params[:close_entry].present?
    @groups_excedeed      = AssignedEmployee.exceeded_staff_for_unit(@period, @unit)
    @entry_incomplete     = entry_incompleted?  if params[:close_entry].present?
    @entry_without_staff  = Indicator.validate_staff_for_entry(@period, @unit)
    @no_changes_unit_staff = changed_unit_staff?
    return @no_changes_unit_staff || @change_staff || @groups_excedeed.present? || @entry_incomplete || @errors_in_out_stock.present? || @entry_without_staff.present?
  end

  def entry_incompleted?
    !(@entry_indicators_cumplimented && @employess_cumplimented)
  end

  def changed_unit_staff?
    (!AssignedEmployeesChange.where(period: @period, unit_id: @unit.id).empty?  && AssignedEmployee.where(staff_of_type: 'UnitJustified', period: @period, unit_id: @unit.id).empty?) if params[:close_entry].present?
  end

  def assigned_employees_update(type, process)
    employess_cumplimented = true
    process.each do |pr|
      grupos = pr[1]
      process_id = pr[0].to_i
      if type == "Unit"
        type = "UnitJustified"
      end
      grupos.keys.each do |grupo|
        quantity = grupos[grupo]
        official_group_id = OfficialGroup.find_by_name(grupo).id
        if quantity.empty?
          employess_cumplimented = false
          delete_assigned_employee(official_group_id, type, process_id)
        else
          unless type == 'UnitJustified' && quantity_equal?(official_group_id, type, process_id, quantity)
            ae = get_assigned_employee(official_group_id, type, process_id)
            ae.quantity = quantity
            ae.updated_by = current_user.login
            ae.save
          end
        end
      end
    end
    return employess_cumplimented
  end

  def quantity_equal?(official_group_id, type, process_id, quantity)
    AssignedEmployee.where(official_group_id: official_group_id, staff_of_type: 'Unit', staff_of_id: process_id, period_id: @period.id, unit_id: @unit.id).sum(:quantity) == quantity.to_f
  end

  def get_assigned_employee(official_group_id, type, process_id)
    AssignedEmployee.find_or_create_by(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: @period.id, unit_id: @unit.id)
  end

  def delete_assigned_employee(official_group_id, type, process_id)
    AssignedEmployee.where(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: @period.id, unit_id: @unit.id).delete_all
  end
end




