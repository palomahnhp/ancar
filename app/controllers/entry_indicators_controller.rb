class EntryIndicatorsController < ApplicationController
  include AssignedEmployeesActions
  include ApprovalsActions

  before_action :require_user, only: [:index]
  before_action :initialize_instance_vars, only: [:index, :edit, :updates, :download_validation ]

  def index
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: "Ficha_#[@unit.description_sap]",
        #        disposition:  'attachment',
                :handlers => [:erb],
                :formats => [:pdf],
                :print_media_type => true
      end
    end
  end

  def download_validation
    pdf = WickedPdf.new.pdf_from_string(render_to_string("index"))
#    pdf = WickedPdf.new.pdf_from_string("Mostrar texto en el pdf")
    send_data pdf, :filename => "Ficha2.pdf", :type => "application/pdf", :disposition => "attachment"
  end

  def updates
    if params[:cancel_change].present?
      cancel_change(@period.id, @unit.id)
    elsif params[:open_change].present?
      open_change(@period.id, @unit.id, current_user)

    elsif params[:approval].present?
      approval
    else
      update_entry
    end

    if (@input_errors[:num_errors] && @input_errors[:num_errors] > 0) || @approval.present?

      render :index
    else
      if params[:close_entry].present?
        flash[:notice] = t('entry_indicators.updates.success.validation')
      elsif params[:cancel_change].present?
        flash[:notice] = t('entry_indicators.updates.success.change')
      elsif params[:save_change].present?
        flash[:notice] = t('entry_indicators.updates.success.save')
      end
      redirect_to entry_indicators_path(unit_id: @unit.id, period_id: @period.id,
      organization_id: @organization.id)
    end
  end

  def approval
    if params[:approval] == "Validar datos"
      validate_input
      if @input_errors[:num_errors] == 0
        @approval = Approval.new(period: @period, unit: @unit, approval_by: current_user.login, official_position: current_user.official_position)
        flash[:notice] = t('entry_indicators.approval.success.validation')
      end
    end
    if params[:approval] == "Visto bueno" || params[:approval] == "Modificar observaciones"
      @approval = set_approval(@period, @unit, params[:comments], current_user)
      flash[:notice] = t('entry_indicators.approval.success.update')
    end
    if params[:approval] == "Cancelar el VºBº"
      @approval = delete_approval(@period, @unit)
      flash[:notice] = t('entry_indicators.approval.success.cancel')
    end

  end

  private
  def update_entry
    @entry_indicators_cumplimented = @employees_cumplimented = true

    params.keys.each do |key|
      case key
          when 'Indicator', 'Unit'
            @employees_cumplimented = assigned_employees_update(key, params[key])
          when 'IndicatorMetric'
            @entry_indicators_cumplimented = update_indicator_metrics(params[key])
          when 'justification'
            @justification_blank = change_justification(@period.id, @unit.id, params[:justification], current_user)
          else
            flash[:error] = t('entry_indicators.updates.no_key')
      end
    end
    validate_input
  end


  def validate_input
      if params[:close_entry].present? || params[:approval].present?

        @input_errors[:assignated_staff]     = AssignedEmployee.staff_for_unit(@period, @unit)
        @input_errors[:entry_without_staff]  = Indicator.validate_staff_for_entry(@period, @unit)
        @input_errors[:entry_incomplete]     = entry_incompleted?
        @input_errors[:in_out_stock]         = SubProcess.validate_in_out_stock(@period, @unit)
        @input_errors[:incomplete_staff_entry] = @incomplete_staff_entry
      end

    if params[:approval].present?
        @input_errors[:entry_incomplete]     = !(entry_indicators_cumplimented? && @incomplete_staff_entry.blank?)
      end

      @input_errors[:incomplete_staff_unit]  = @incomplete_staff_unit
      @input_errors[:justification_blank]    = @justification_blank
      if @input_errors[:justification_blank] && @input_errors[:incomplete_staff_unit].count == OfficialGroup.count
        @input_errors[:cancel_change] = true
        @input_errors[:incomplete_staff_unit]  = nil
        @input_errors[:justification_blank]    = nil
        @input_errors[:assignated_staff] = nil
      end
      @input_errors[:num_errors] = @input_errors.select{|error| @input_errors[error].present?}.count
    end

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
            delete_entry_indicators(@unit.id, indicator_metric_id)
            @entry_indicators_cumplimented = false
          else
            ei = EntryIndicator.find_or_create_by(unit_id: @unit.id, indicator_metric_id: indicator_metric_id)
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
      @input_errors = Hash.new()
      @incomplete_staff_unit = []
      @incomplete_staff_entry = {}

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

      @approval = get_approval(@period, @unit)
    end

    def entry_incompleted?
      !(@entry_indicators_cumplimented && @incomplete_staff_entry)
    end

    def assigned_employees_update(type, process)
      employees_cumplimented = true

      process.each do |pr|
        grupos = pr[1]
        process_id = pr[0].to_i
        if type == 'Unit'
          type = 'UnitJustified'
        end
        grupos.keys.each do |grupo|
          quantity = grupos[grupo]
          official_group_id = OfficialGroup.find_by_name(grupo).id
          if quantity.blank?
            employees_cumplimented = false
            if type == 'UnitJustified'
              @incomplete_staff_unit <<  grupo
            elsif
              @incomplete_staff_entry[process_id.to_s] = []
              @incomplete_staff_entry[process_id.to_s] << grupo
            end
            delete_assigned_employee(official_group_id, type, process_id, @period.id, @unit.id)
          else
            ae = get_assigned_employee(official_group_id, type, process_id, @period.id, @unit.id)
            ae.quantity = quantity
            ae.updated_by = current_user.login
            ae.save
          end
        end
      end
      return employees_cumplimented
    end

    def entry_indicators_cumplimented?
      indicators_period = @period.indicators(@unit)
      indicators_period.each do |indicator_subprocess|
        indicator_subprocess.each do |indicator|
            indicator.indicator_metrics.each do |indicator_metric|
              return false if indicator_metric.entry_indicators.where(unit: @unit).blank?
            end
        end
      end
      return true
    end

 end
