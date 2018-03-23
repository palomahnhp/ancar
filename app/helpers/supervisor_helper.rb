module SupervisorHelper
  def side_menu
    render "/#{namespace}/menu"
  end

  def organization_type_options
    @organization_types.collect { |v| [ v.description, v.id ] }
  end

  def main_process_items
    select_process_items('main_process')
  end

  def sub_process_items
    select_process_items('sub_process')
  end

  def indicator_items
    select_process_items('indicator')
    items_not_used = Item.where(item_type: 'indicator').order(:description)
    items_not_used.collect  { |v| [ v.description, v.id] }
  end

  def select_process_items(class_name)
    items_not_used = Item.where(item_type: class_name).order(:description)
    items_not_used.collect  { |v| [ v.description, v.id] }
  end

  def metric_items
    select_items('metric')
  end

  def source_items(id, fixed=false)
    if fixed
      Source.fixed.collect  { |v| [ v.item.description, v.item.id ]}
    else
      select_items('source')
    end
  end

  def total_indicator_type_items
    select_items('total_indicator_type')
  end

  def select_items(class_name, id=nil)
    items_not_used = Item.where(item_type: class_name).active.order(:description)
    items_not_used.collect  { |v| [ v.description, Object.const_get(class_name.camelize).find_by_item_id(v.id).id ] if Object.const_get(class_name.camelize).find_by_item_id(v.id).present? }
  end

  def total_check(indicator_metric_id, summary_type_id)
    summary_type = SummaryType.find_id(summary_type_id)
    total_indicators = summary_type.total_indicators.find_by_indicator_metric_id(indicator_metric_id)
    if total_indicators.nil?
      '-'
    else
      total_indicators.in_out.nil? ? 'X' : total_indicators.in_out
    end
  end

  def main_process_period_id
    @main_process.period_id.nil? ? params[:period_id] : @main_process.period_id
  end

  def delete_msg(class_name, eliminable, modifiable, empty)
    if modifiable && !empty
      t("supervisor.delete.message.no_empty")
    else
      t("supervisor.delete.message.empty")
    end
  end

  def show_errors(object, field_name)
    if object.errors.any?
      unless object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(', ')
      end
    end
  end

  def summary_type_selected(indicator_metric_id, summary_type_id)
    summary_type = SummaryType.find_id(summary_type_id)
    ti = summary_type.total_indicators.find_by_indicator_metric_id(indicator_metric_id)
    if ti.nil?
      in_out = '-'
    elsif
      in_out = ti.in_out.nil? ? 'A' : ti.in_out
    end
    TotalIndicatorType.acronym_id(in_out)
  end

  def supervisor_get_employee_change(id)
    @employee_change ||=  AssignedEmployeesChange.find(id) if id.present? && id > 0
  end

  def supervisor_get_approval(id)
    @approval ||=  Approval.find(id) if id.present?  && id > 0
  end

  def change_id?(id)
    if @prev_id == id
      false
    else
      @prev_id = id
      true
    end
  end

  def organization_loaded?(organization, year)
    "icon-check" if Rpt.by_organization(organization).by_year(year).present?
  end

  def rpt_settings
    rpt  = Setting.all.group_by { |s| s.type if s.type.start_with?('rpt.') && s.type.present? }.keys
    rpt.delete(nil)
    rpt
  end

  def rpt_condition_enabled?(condition, acronym)
    setting = Setting.find_by(key: condition + '.' + acronym)
    setting.enabled? if setting.present?
  end

  def rpt_unit(year, unit, grtit= "")
    if @conditions[:vacancy].present?
      @rpt_grtit = Rpt.select('grtit_per').by_year(year).by_unit_sap(unit).group(:grtit_per).count
     else
      @rpt_grtit = Rpt.select('grtit_per').by_year(year).by_unit_sap(unit).occupied.group(:grtit_per).count
    end
    tot = 0
    @rpt_grtit.map do |rpt|
      tot+= rpt[1]
    end
    tot
  end

  def rpt_organization(year, organization, grtit= "")
    if @conditions[:vacancy].present?
      return organization.rpts.by_year(year).count if grtit.blank?
      organization.rpts.by_year(year).send(grtit).count
    else
      return organization.rpts.by_year(year).occupied.count if  grtit.blank?
      organization.rpts.by_year(year).occupied.send(grtit).count
    end
  end

  def rpt_load_conditions(type)
    condition_txt = 'Se incluyen '
    @conditions = {}
    if rpt_condition_enabled?('rpt.vacancy', type.acronym)
      condition_txt += 'puestos vacantes '
      @conditions[:vacancy] = true
    else
      condition_txt += 'solo puestos ocupados '
      @conditions[:vacancy] = false
    end
    if rpt_condition_enabled?('rpt.only_grtit', type.acronym)
      condition_txt += ' y con grupo de titulación'
      @conditions[:only_grtit] = true
    else
      condition_txt += ' y sin grupo de titulación: laborales, eventuales, directivos y cargos electos'
      @conditions[:only_grtit] = false
    end
    condition_txt
  end

  def unit_assigned_rpt(year, organization, unit, grtit)
    grtit = 'agr' if grtit == 'e'
    @loaded_rpt = false if grtit == 'a1'
    @period ||= Period.by_year(year).by_organization_type(organization.organization_type).take
    assigned = AssignedEmployee.staff_from_unit(unit, @period, OfficialGroup.find_by(name: grtit.capitalize))
    @loaded_rpt = true  if assigned.present?
    return assigned if assigned.present?

    rpt_unit(year, unit.sap_id, grtit= "")
  end

  private
  
    def namespace
      controller.class.parent.name.downcase
    end
end
