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

  def source_selected
    is = IndicatorSource.find_by_indicator_metric_id(params[:id])
    is.nil? ? ' ' : is.source_id
  end

  def metric_items
    select_items('metric')
  end

  def source_items
    select_items('source')
  end

  def total_indicator_type_items
    select_items('total_indicator_type')
  end

  def select_items(class_name)
    items_not_used = Item.where(item_type: class_name).order(:description)
    items_not_used.collect  { |v| [ v.description, Object.const_get(class_name.camelize).find_by_item_id(v.id).id] }
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
      t("validator.#{class_name}.delete.message.no_empty")
    else
      t("validator.#{class_name}.delete.message.empty")
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

  private
    def namespace
      controller.class.parent.name.downcase
    end

end
