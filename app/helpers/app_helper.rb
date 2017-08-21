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
    entry_indicator = indicator_metric.entry_indicators.where(unit_id: @unit.id).take
    if entry_indicator.present? && entry_indicator.amount != entry_indicator.imported_amount && source_imported?(indicator_metric)
      description += ' (*)'
    end

    return description
  end

  def get_source_id(indicator_metric)
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

  def in_out_error(error)
    "#{SubProcess.description(error[0])}-  salida: #{error[1][0]} entrada: #{error[1][1]} stock: #{error[1][2]} "
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

  def source_editable?(indicator_metric, period, user)
    if source_imported?(indicator_metric) # automatic font
      setting_key = 'imported_sources_editable.'
      if period.is_from?('SGT')
        setting_key  = setting_key + 'SGT'
      elsif period.is_from?('JD')
        setting_key  = setting_key + 'JD'
      end
      setting[setting_key].present? && setting[setting_key] == 'TRUE'
    else
      true
    end
  end

  def input_allowed?(period, organization, approval, indicator_metric, user)
    if user.has_role? :admin
      return true
    else
      period.open_entry? && (can? :updates, organization)  && approval.blank? && source_editable?(indicator_metric, period, user)
    end
  end

  def period_status_text(period)
    period.open_entry? ? (period.description) + " \n(" + t('status.open') + ' de ' + (l period.opened_at) + ' a ' + (l period.closed_at) + ')' : (period.description) + ' (' + t('status.close') +')'
  end

  def link_doc_target(format)
    format == 'HTML' ? '_self' : '_blank'
  end

  def source_imported?(indicator_metric)
    indicator_metric.indicator_sources.map{ |is| return is.source.fixed? }
    false
  end

end
