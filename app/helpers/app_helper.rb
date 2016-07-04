module AppHelper

  def description(id, item_id)
    if id == 0
     "#{Item.find(item_id).description}"
    else
     "#{id}. #{Item.find(item_id).description}"
    end
  end

  def sources_description(id, sources)
    description = ""
    sources.all.each do |source|
      description += source.item.description.to_s
    end
    return description
  end

  def get_staff(type, proc, group, unit)

    ae = AssignedEmployee.where(staff_of_id: proc.id, staff_of_type: type, official_group_id: group.id, unit_id: unit.id).first
    return ae.nil? ? 0 : ae.quantity
  end

  def get_in_out(im)

    in_out = Metric.find(im.metric_id).in_out
    case in_out
    when "in"
      "Entrada"
    when "out"
      "Salida"
    when "stock"
      "Stock"
    else
      "Por determinar"
    end
  end

  def get_amount(im, unit)
    ei = EntryIndicator.where(indicator_metric_id: im.id, unit_id: unit.id).first
    amount = ei.nil? ? 0 : ei.amount
  end

  def get_metric(im)
    description(0, Metric.find(im.metric_id).item_id)
  end

  def current_path_with_query_params(query_parameters)
    url_for(request.query_parameters.merge(query_parameters))
  end

  def sub_processes_unit(main_process, unit)
    main_process.sub_processes.where(unit_type_id: unit.unit_type_id).order(:order)
  end
end
