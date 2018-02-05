class EntryIndicatorsController < ApplicationController
  include AssignedEmployeesActions
  include ApprovalsActions
  include ApprovalsActions

  before_action :require_user, only: [:index]
  before_action :initialize_instance_vars, only: [:index, :edit, :updates, :download_validation, :validated_abstract]

  def index
    flash[:notice] = t('entry_indicators.index.no_update_role') if (@period.open_entry? && (cannot? :updates, @organization))
  end

  def updates
    if cancel_change?
      cancel_change(@period.id, @unit.id)
      SupervisorMailer.change_staff_email(change: 'cancel', period: @period, unit:@unit,
                                          user: current_user).deliver_now #deliver_later
    elsif open_change?
      open_change(@period.id, @unit.id, current_user)
    elsif approval?
      approval
    else
      update_entry
    end

    if !save_change? && (@input_errors.present? || @approval.present?)
      render :index
    else
      if validate_entry?
        flash[:notice] = t('entry_indicators.updates.success.validation')
      elsif cancel_change?
        flash[:notice] = t('entry_indicators.updates.success.change')
      elsif save_change?
        flash[:notice] = t('entry_indicators.updates.success.save_html')
      end
      redirect_to entry_indicators_path(unit_id: @unit.id, period_id: @period.id,
      organization_id: @organization.id)
    end
  end

  def approval
    case params[:approval]
      when t('entry_indicators.form.button.approval.init')
        validate_input
        if @input_errors.blank?
          @approval = Approval.new(period: @period, unit: @unit, approval_by: current_user.login,
                                   official_position: current_user.official_position)
          flash[:notice] = t('entry_indicators.approval.success.validation')
        end
      when t('entry_indicators.form.button.approval.ok') ||
          params[:approval] == t('entry_indicators.form.button.approval.update')
        @approval = set_approval(@period, @unit, params[:comments], current_user)
        flash[:notice] = t('entry_indicators.approval.success.update')
      when t('entry_indicators.form.button.approval.cancel')
        @approval = delete_approval(@period, @unit)
        flash[:notice] = t('entry_indicators.approval.success.cancel')
    end
  end

  def download_validation
    #  pdf = WickedPdf.new.pdf_from_string(render_to_string("entry_indicators/index", layout: false))
    body_html   = render_to_string("entry_indicators/index.pdf" )
    pdf = WickedPdf.new.pdf_from_string(
        body_html,
        margin: {
            bottom: 20,
            top: 30
        },
        outline: {
            outline: true,
            outline_depth: 3 },
        footer: {
            margin: {top: 30 },
            left:   "",
            right: 'Pág. [page] / [topage]',
            center:  "" ,
            font_name: 'Arial',
            font_size: 8
        },
    )
    send_data pdf, :filename => "Ficha_attachment.pdf",
              :type => "application/pdf",
              :disposition => "inline",
              layouts: "layouts/pdf.html.erb"
  end

  def validated_abstract
    body_html   = render_to_string("entry_indicators/validated_abstract.pdf" )
    pdf = WickedPdf.new.pdf_from_string(
        body_html,
        #        orientation: 'Landscape',
        margin: { bottom: 20, top: 15 },
        footer: {
            margin: {top: -30 },
            #            left:   "\n#{@period.description}\n#{@unit.description_sap}",
            right: 'Pág. [page] / [topage]',
            center:  "" ,
            font_name: 'Arial',
            font_size: 8
        },
    )
    send_data pdf, :filename => "VistoBueno_#{@unit.description_sap}.pdf",
              :type => "application/pdf",
              :disposition => "inline"
  end

  private

  def update_entry
    remove_last_validation if validate_entry?
    params.keys.each do |key|
      case key
          when 'Indicator', 'Unit'
            assigned_employees_update(key, params[key])
          when 'IndicatorMetric'
            update_indicator_metrics(params[key])
          when 'justification'
            create_validation(:no_justification) unless change_justification(@period.id, @unit.id, params[:justification], current_user)
          else
            flash[:error] = t('entry_indicators.updates.no_key')
      end
    end
    validate_input if validate_entry? || approval?
  end

  def validate_input
    data = AssignedEmployee.staff_for_unit(@period, @unit)
    create_validation(:assigned_staff, data) if data.present?
    data = Indicator.validate_staff_for_entry(@period, @unit)
    create_validation(:entry_without_staff, data[0]) if data[0].present?
    create_validation(:staff_without_entry, data[1]) if data[1].present?
#        data = SubProcess.validate_in_out_stock(@period, @unit)
#        create_validation(:in_out_stock, data) if data.present?
#      when @justification_blank.present? &&
#           @input_errors.by_key(:incomplete_staff_unit).count == OfficialGroup.count
#          create_validation(:cancel_change)
    @input_errors = Validation.by_period(@period.id).by_unit(@unit.id)
    create_validation(:success_validation) if @input_errors.blank?
  end

  def entry_indicator_params
    params.require(:entry_indicator).permit(:imported_amount, :amount, :unit_id, :period_id, :indicator_metric, :indicator_source)
  end

  def update_indicator_metrics(indicator_metrics)
    Indicator.includes(:indicator_metrics,:entry_indicators)
    indicator_metrics.each do |indicator|
      indicator[1].each do |im|
        indicator_metric_id = im[0].to_i
        amount = im[1]
        if amount.empty?
          delete_entry_indicators(@unit.id, indicator_metric_id)
        else
          ei = EntryIndicator.find_or_create_by(unit_id: @unit.id, indicator_metric_id: indicator_metric_id)
          amount = amount.tr('.', '').tr(',', '.').to_f
          unless ei.amount == amount
            ei.amount = amount
            ei.imported_amount = ei.amount if ((current_user.has_role? :admin) && (source_imported?(ei.indicator_metric)))
            ei.period_id = @period.id
            ei.updated_by = current_user.login
            ei.save
          end
        end
      end
    end
    return
  end

  def initialize_instance_vars
    @input_errors = Hash.new()
    if params[:organization_id]
      @organization = Organization.find(params[:organization_id])
      @units = @organization.units.order(:order).to_a
    end
    if params[:period_id]
      @period = Period.includes(
          :assigned_employees,
          :entry_indicators,
          main_processes:
            [sub_processes:
              [tasks:
                [indicators:
                  [indicator_metrics:
                    [metric:
                      [:item]],
                   indicator_sources:
                      [source:
                           [:item]]
                ]
              ]
            ]
          ]
         ).find(params[:period_id]) if params[:period_id]
    end
    if params[:unit_id]
      @unit = Unit.find(params[:unit_id])
    else
      @unit = @units.first
    end
    @approval = get_approval(@period, @unit)
  end

  def assigned_employees_update(type, process)
    unit_ae_modified = false
    incomplete_staff_unit = []
    incomplete_staff_entry = []
    process.each do |pr|
      grupos = pr[1]
      process_id = pr[0].to_i
      if type == 'Unit'
        type = 'UnitJustified'
      end
      grupos.keys.each do |grupo|
        quantity = grupos[grupo]
        official_group = OfficialGroup.find_by_name(grupo)
        if quantity.blank?
          if type == 'UnitJustified'
            error = "Unidad: " + @unit.description_sap +  " " + official_group.description
            incomplete_staff_unit.push(error)
          else
            error = Indicator.description(process_id) + " => " + official_group.description
            incomplete_staff_entry.push(error)
          end
          delete_assigned_employee(official_group.id, type, process_id, @period.id, @unit.id)
        else
          ae = set_assigned_employee(official_group.id, type, process_id, @period.id, @unit.id)
          ae.quantity = quantity
          if ae.changed?
            ae.updated_by = current_user.login
            ae.save
            unit_ae_modified = true if type == 'UnitJustified'
          end
        end
      end
    end
    SupervisorMailer.change_staff_email(change: 'open', period: @period, unit:@unit, user: current_user).deliver_now if unit_ae_modified.present?
    create_validation(:incomplete_staff_unit, incomplete_staff_unit) if incomplete_staff_unit.present?
    create_validation(:incomplete_staff_entry, incomplete_staff_entry) if incomplete_staff_entry.present?
    return
  end

  def for_approval
    params[:close_entry].present? || params[:approval].present?
  end

  def create_validation(key, data='')
    Validation.add(@period, @unit, key, t("entry_indicators.form.error.title.#{key}"),
                   t("entry_indicators.form.error.p1.#{key}_html"), data, current_user.login)
  end

  def validate_entry?
    params[:close_entry].present?
  end

  def cancel_change?
    params[:cancel_change].present?
  end

  def open_change?
    params[:open_change].present?
  end

  def save_change?
    params[:updates].present?
  end

  def approval?
    params[:approval].present?
  end

  def remove_last_validation
    Validation.delete_all(period: @period, unit: @unit)
  end
end
