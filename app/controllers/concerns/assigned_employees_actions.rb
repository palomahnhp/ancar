module AssignedEmployeesActions
  extend ActiveSupport::Concern

  def open_change(period_id, unit_id, current_user)
    AssignedEmployeesChange.initialize_change(period_id, unit_id, current_user)
    AssignedEmployee.initialize(period_id, unit_id, current_user)
  end

  def change_justification(period_id, unit_id, justification, current_user)
    AssignedEmployeesChange.change_justification(period_id, unit_id, justification, current_user)
  end

  def cancel_change(period_id, unit_id)
    AssignedEmployeesChange.cancel(period_id, unit_id)
    AssignedEmployee.cancel(period_id, unit_id)
  end

  def has_justification?((unit_id, period_id))
    params[:justification].present?  && has_change(unit_id, period_id)
  end

  def has_change?(unit_id, period_id)
    AssignedEmployeesChange.unit_justified(unit_id, period_id)
  end

  def delete_assigned_employee(official_group_id, type, process_id, period_id, unit_id)
    AssignedEmployee.delete_all_by_group(official_group_id, type, process_id, period_id, unit_id)
  end

  def set_assigned_employee(official_group_id, type, process_id, period_id, unit_id)
    AssignedEmployee.set_by_group(official_group_id, type, process_id, period_id, unit_id)
  end

  def delete_entry_indicators(unit_id, indicator_metric_id)
    EntryIndicator.delete_by_indicator_metric(unit_id, indicator_metric_id)
  end

  def source_imported?(indicator_metric)
    indicator_metric.indicator_sources.map{ |is| return is.source.fixed? }
  end
end