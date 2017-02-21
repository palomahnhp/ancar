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

  def sources_description(indicator_metric)
    description = ''
    indicator_metric.indicator_sources.all.each do |indicator_source|
      description += ', ' unless description == ''
      description += indicator_source.source.item.description.to_s
      specification = indicator_metric.entry_indicators.where(unit_id: @unit.id).take.nil? ? nil :
          indicator_metric.entry_indicators.where(unit_id: @unit.id).take.specifications
      unless specification.nil?
        description += ': '
        description += specification
      end
    end
    return description
  end

  def source_id(indicator_metric)
    indicator_metric.indicator_sources.take.nil? ? "-" : indicator_metric.indicator_sources.take.source_id
  end

#  def metric_id
#    indicator.indicator_metrics.take.nil? ? "-" : indicator.indicator_metrics.take.source_id
#  end

  def get_staff(type, proc, group, unit, period)
    if type == 'SubProcess'
      ids = proc.indicators.ids
      type = 'Indicator'
    else
      ids =  proc.id
    end
    ae = AssignedEmployee.where(staff_of_id: ids, staff_of_type: type, official_group_id: group.id, unit_id: unit.id, period_id: period.id).sum(:quantity)
    return ae.nil? ? nil : format_number(ae)
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

  def process_name(period, process)
    process_name = period.organization_type.process_names.find_by_model(process.snakecase.pluralize)
    process_name.nil? ? process : process_name.name.camelize
  end

end
