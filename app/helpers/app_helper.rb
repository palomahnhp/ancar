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
    indicator_metric.indicator_sources.take.nil? ? '-' : indicator_metric.indicator_sources.take.source_id
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

  def format_number(num)
    num = 0 if num.nil?
    number_to_currency(num, {:unit => '', :separator => ',', :delimiter =>
  '.', :precision => 2})
  end

  def process_name(period, process)
    process_name = period.organization_type.process_names.find_by_model(process.snakecase.pluralize)
    process_name.nil? ? process.camelize : process_name.name.camelize
  end

  def entry_staff_error(entry_error)
    description = "#{Indicator.description(entry_error[0])}=> cantidad: #{entry_error[1][0].to_f} puesto asignado #{entry_error[1][1].to_f}"
  end

  def in_out_error(errors_in_out_stock)
      description = "\r\n"
      errors_in_out_stock.each do |e|
        description  += "#{SubProcess.description(e[0])}-  salida: #{e[1][0]} entrada: #{e[1][1]} stock: #{e[1][2]} \r\n"
      end
      return description

    end

    def pos_amount(of)
      (of == 'SubProcess' || of == 'Indicator' ) ? 3 : 4
    end

    def official_groups
      @official_groups ||=  OfficialGroup.all
    end

  def user_type(current_user)
    if current_user.has_role? :interlocutor, :any
      'interlocutor'
    else
      'no_interlocutor'
    end
  end

  def resources_select_options(user, class_name)
    grouped_resources = {}
    grouped_resources[' '] = ['Selecciona el ambito de autorización', '']
    if class_name == Organization
      OrganizationType.all.each do |type|
        grouped_resources[type.description] = Organization.select_options(type)
      end
    elsif class_name == OrganizationType
      grouped_resources['Tipos de organizaciones'] = OrganizationType.select_options
    end

    return grouped_resources
  end

  def roles_select_options(user, class_name)
    roles = []
    roles << ['Selecciona el rol a asignar', '']
    User.roles_select_options(class_name).each do |r|
      roles << r
    end
  end

  def source_editable?(indicator_metric, period)
     if setting['imported_sources_no_editable'].present? && eval(setting['imported_sources_no_editable']) && period.organization_type.acronym == 'SGT'
      indicator_metric.indicator_sources.map{ |i_s|  return !i_s.source.imported.present? }
     else
       true
     end
  end

end
