module IndicatorHelper
  def description(id, item_id)
    if id.zero?
       Item.find(item_id).description
    else
      id.to_s + '.' + Item.find(item_id).description
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
    description
  end

  def get_source_id(indicator_metric)
    indicator_metric.indicator_sources.take.nil? ? '-' : indicator_metric.indicator_sources.take.source_id
  end

  def get_amount(im, unit)
    ei = EntryIndicator.where(indicator_metric_id: im.id, unit_id: unit.id).first
    ei.nil? ? nil : format_number(ei.amount)
  end

  def get_metric(im)
    description(0, Metric.find(im.metric_id).item_id)
  end

  def process_name(period, process)
    process_name = period.organization_type.process_names.find_by(model: process.snakecase
                                                                             .pluralize)
    process_name.nil? ? process.camelize : process_name.name.camelize
  end

  def entry_staff_error(entry_error)
    "#{Indicator.description(entry_error[0])}=> cantidad: #{entry_error[1][0].to_f} puesto asignado #{entry_error[1][1].to_f}"
  end

  def in_out_error(error)
    "#{SubProcess.description(error[0])}-  salida: #{error[1][0]} entrada: #{error[1][1]} stock: #{error[1][2]} "
  end

  def pos_amount(of)
    return 3 if %w(SubProcess Indicator).include? of
    4
  end

  def official_groups
    @official_groups ||=  OfficialGroup.all
  end

  def source_editable?(indicator_metric, period)
    if source_imported?(indicator_metric) # automatic font
      setting_key = 'imported_sources_editable.' + period.organization_type.acronym
      Setting.find_by(key: setting_key).enabled?
    else
      true
    end
  end

  def input_allowed?(period, organization, approval, indicator_metric, user)
    return true if user.has_role? :admin
    period.open_entry? && (can? :updates, organization)  && approval.blank? &&
      source_editable?(indicator_metric, period)
  end

  def period_status_text(period)
    period.open_entry? ? period.description + " \n(" + t('status.open') + ' de ' +
        (l period.opened_at) + ' a ' + (l period.closed_at) + ')' : (period.description) + ' (' +
        t('status.close') +')'
  end

  def source_imported?(indicator_metric)
    indicator_metric.indicator_sources.map { |is| return is.source.fixed? }
    false
  end
end