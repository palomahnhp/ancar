module AppHelper

  def description(id, item_id)
    if id == 0 then
      "#{# noinspection RailsChecklist05
      Item.find(item_id).description}"
    else
      "#{id}. #{# noinspection RailsChecklist05
      Item.find(item_id).description}"
    end
  end

  def sources_description(sources)
    description = ''
    sources.all.each do |source|
      description += ', ' unless description == ''
      description += source.item.description.to_s
    end
    return description
  end
  def source_id(indicator)
    indicator.indicator_sources.take.nil? ? "-" : indicator.indicator_sources.take.source_id
  end

  def metric_id
    indicator.indicator_metrics.take.nil? ? "-" : indicator.indicator_metrics.take.source_id
  end

  def get_staff(type, proc, group, unit, period)
    ae = AssignedEmployee.where(staff_of_id: proc.id, staff_of_type: type, official_group_id: group.id, unit_id: unit.id, period_id: period.id).first
    return ae.nil? ? nil : format_number(ae.quantity)
  end

  def get_amount(im, unit)
    ei = EntryIndicator.where(indicator_metric_id: im.id, unit_id: unit.id).first
    return ei.nil? ? nil : format_number(ei.amount)
  end

  def get_metric(im)
    # noinspection RailsChecklist05
    description(0, Metric.find(im.metric_id).item_id)
  end


  def current_path_with_query_params(query_parameters)
    url_for(request.query_parameters.merge(query_parameters))
  end

  def sub_processes_unit(main_process, unit)
    main_process.sub_processes.where(unit_type_id: unit.unit_type_id).order(:order)
  end

  def format_number(num)
    number_to_currency(num, {:unit => '', :separator => ',', :delimiter =>
  '.', :precision => 2})
  end
end
