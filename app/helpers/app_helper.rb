module AppHelper

  def description(id, item_id)
    if id == 0
     "#{Item.find(item_id).description}"
    else
     "#{id}. #{Item.find(item_id).description}"
    end
  end

  def sources(id)
    Indicator.find(id).sources
  end

  def get_amount(indicator)
    indicator.entry_indicator.first.amount
  end

  def get_staff(type, proc, group)
    ae = AssignedEmployee.where(staff_of_id: proc.id, staff_of_type: type, official_groups_id: group.id).first
    return ae.quantity
  end

  def current_path_with_query_params(query_parameters)
    url_for(request.query_parameters.merge(query_parameters))
  end

  def sub_processes_unit(main_process, unit)
    main_process.sub_processes.where(unit_type_id: unit.unit_type_id)
  end
end