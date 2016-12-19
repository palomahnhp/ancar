module ManagerHelper

  def side_menu
    render "/#{namespace}/menu"
  end

  def organization_type_options
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

  def total_check(indicator_metric_id, item_summary_type_id)
    summary_type = @summary_types.find_by_item_id(item_summary_type_id)
    total_indicators = summary_type.total_indicators.find_by_indicator_metric_id(indicator_metric_id)
    if total_indicators.nil?
      '-'
    else
      total_indicators.in_out.nil? ? 'X' : total_indicators.in_out
    end
  end

  def unit_type_description(id)
    # noinspection RailsChecklist05
    @unit_type_description = UnitType.find(id).description
  end

  def delete_msg(class_name, eliminable, modifiable, empty)
    if modifiable && !empty
      t("manager.#{class_name}.delete.message.no_empty")
    else
      t("manager.#{class_name}.delete.message.empty")
    end
  end

  def show_errors(object, field_name)
    if object.errors.any?
      unless object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(", ")
      end
    end
  end

  def summary_type_selected(indicator_metric_id, item_summary_type_id)
    summary_type = @summary_types.find_by_item_id(item_summary_type_id)
    ti = summary_type.total_indicators.find_by_indicator_metric_id(indicator_metric_id)
    if ti.nil?
      in_out = "-"
    elsif
      in_out = ti.in_out.nil? ? 'A' : ti.in_out
    end
    t("manager.indicators.total_indicator_type.#{in_out}")
  end

  private
    def namespace
      controller.class.parent.name.downcase
    end

end
