class EntryIndicatorsController < ApplicationController
  before_action :require_user, only: [:index]
  before_action :initialize_instance_vars, only: [:index, :edit, :updates ]
  respond_to :html, :js

  def index
    if params[:organization_id] && params[:period_id]
      if @period.main_processes.empty?
        render :index, notice: t("entry_indicators.index.no_main_processes")
      end
    end
  end

  def updates
    @entry_indicators_cumplimented = @employess_cumplimented = true
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

    @groups_excedeed = AssignedEmployee.exceeded_staff_for_unit(@unit.id, @period.id)
    if @groups_excedeed.present?
      render :edit
    else
      if all_cumplimented?
        flash[:notice] = t('entry_indicators.updates.success')
      else
        flash[:alert] = t('entry_indicators.updates.incomplete')
      end
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
        @period = Period.find(params[:period_id]) if params[:period_id]
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
            ae.justification = params[:justification]
            ae.save
          end
        end
      end
    end

    def update_entry_indicators(indicator_metrics)
      indicator_metrics.each do |im|
        indicator_metric_id = im[0].to_i
        amount = im[1]
        if amount.empty?
          @entry_indicators_cumplimented = false
          EntryIndicator.where(unit_id: @unit.id, indicator_metric_id: indicator_metric_id).delete_all
        else
          ei = EntryIndicator.find_or_create_by(unit_id: @unit.id, indicator_metric_id: indicator_metric_id)
          ei.indicator_source_id = IndicatorSource.where(indicator_metric: indicator_metric_id).take.id
          ei.amount = amount
          ei.period_id = @period.id
          ei.updated_by = current_user.login
          ei.save
        end
      end
    end

    def all_cumplimented?
      @entry_indicators_cumplimented && @employess_cumplimented
    end
end
