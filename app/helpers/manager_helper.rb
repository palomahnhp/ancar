module ManagerHelper

  def side_menu
    render "/#{namespace}/menu"
  end

  def organization_type_select_options
    @organization_types.collect { |v| [ v.description, v.id ] }
  end

  def period_select_options
    @periods.collect { |v| [ v.description, v.id ] }
  end

  def main_process_items
    mp = MainProcess.all.uniq.pluck(:id)
    items_not_used = Item.where(item_type: "main_process").where.not(id: mp)
    items_not_used.collect  { |v| [ v.id, v.id ] }
  end

  def indicator_items
    select_items("indicator")
  end

  def metric_items
    select_items("metric")
  end

  def select_items(class_name)
    items_not_used = Item.where(item_type: class_name).order(:description)
    items_not_used.collect  { |v| [ v.description, v.id ] }
  end

  def total_check(indicator_metric, item_summary_type_id)
    summary_type = SummaryType.where(item_id: item_summary_type_id).take
    if ! indicator_metric.nil?
      total_indicators = TotalIndicator.where(indicator_metric_id: indicator_metric.id, summary_type_id: summary_type.id)
      if total_indicators.count == 0
       '-'
      else
        total_indicators.take.in_out.nil? ? 'X' : total_indicators.take.in_out
      end
    else
      '-'
    end
  end

  def unit_type_description(id)
    @unit_type_description = UnitType.find(id).description
  end

  def delete_msg(class_name, eliminable, modifiable, empty)
    if modifiable && !empty
      t("manager.#{class_name}.delete.message.no_empty")
    else
      t("manager.#{class_name}.delete.message.empty")
    end
  end

  def summary_type_checked?(indicator, item_summary_type_id)
    if indicator.id.nil?
    else
      summary_type_id = SummaryType.where(item_id: item_summary_type_id).take.id
      !TotalIndicator.where(indicator_metric_id: indicator.indicator_metrics.take.id, summary_type_id: summary_type_id).empty?
    end
  end

  def show_errors(object, field_name)
    if object.errors.any?
      if !object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(", ")
      end
    end
  end

  def indicator_description(indicator, item_id)
    if !indicator.item_id.nil?
      indicator.item.description
    elsif !item_id.nil?
      Item.find(item_id).description
    else
      ""
    end
  end

  private
    def namespace
      controller.class.parent.name.downcase
    end
end
