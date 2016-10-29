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
    items_not_used = Item.where(item_type: "indicator").order(:description)
    items_not_used.collect  { |v| [ v.description, v.id ] }
  end

  def metric_items
    items_not_used = Item.where(item_type: "metric").order(:description)
    items_not_used.collect  { |v| [ v.description, v.id ] }
  end

  def total_check(indicator_metric_id, indicator_type_id)
    TotalIndicator.where(indicator_metric_id: indicator_metric_id, indicator_type: indicator_type_id).count == 0 ? '.' : 'X'
  end

  def unit_type_description(id)
    @unit_type_description = UnitType.find(id).description
  end

  def delete_msg(class_name, count=0)
    if class_name != Period.class.name
      t("manager.#{class_name.pluralize.underscore}.delete.message")
    elsif count == 0
      t("manager.#{class_name..pluralize.underscore}.delete.message.no_empty")
    else
      t("manager.#{class_name..pluralize.underscore}.delete.message")
    end

  end

  def summary_type_checked?(indicator, item_summary_type_id)
    summary_type_id = SummaryType.where(item_id: item_summary_type_id).take.id
    !TotalIndicator.where(indicator_metric_id: indicator.indicator_metrics.take.id, summary_type_id: summary_type_id).empty?
  end

  private
    def namespace
      controller.class.parent.name.downcase
    end
end
