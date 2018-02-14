namespace :initialize do

  desc "Inicializar summary_types"
  task summary_types: :environment do
    puts " Iniciado proceso"
    TotalIndicator.update_all(summary_type_id: nil)
    SummaryType.delete_all
    Item.where(item_type: "summary_type").delete_all

    process     = Item.create!(item_type: "summary_type", description: "Proceso", updated_by: "initialize")
    subprocess  = Item.create!(item_type: "summary_type", description: "Subproceso", updated_by: "initialize")
    stock       = Item.create!(item_type: "summary_type", description: "Stock", updated_by: "initialize")
    sub_subprocess = Item.create!(item_type: "summary_type", description: "Sub-subproceso", updated_by: "initialize")
    control     = Item.create!(item_type: "summary_type", description: "Control", updated_by: "initialize")

    pr = SummaryType.create(acronym: "P", item_id:process.id,     order: 1, updated_at: 'initialize', active: TRUE)
    s  = SummaryType.create(acronym: "S", item_id:subprocess.id,  order: 2, updated_at: 'initialize', active: TRUE)
    u  = SummaryType.create(acronym: "U", item_id:stock.id,       order: 4, updated_at: 'initialize',  active: TRUE)
    g  = SummaryType.create(acronym: "G", item_id:sub_subprocess.id, order: 3, updated_at: 'initialize',  active: FALSE)
    c  = SummaryType.create(acronym: "C", item_id:control.id,     order: 5, updated_at: 'initialize',  active: FALSE)

    TotalIndicator.where(indicator_type: "P").update_all(summary_type_id: pr.id)
    TotalIndicator.where(indicator_type: "S").update_all(summary_type_id: s.id)
    TotalIndicator.where(indicator_type: "U").update_all(summary_type_id: u.id)
    TotalIndicator.where(indicator_type: "G").update_all(summary_type_id: g.id)
    TotalIndicator.where(indicator_type: "C").update_all(summary_type_id: c.id)
    puts " Ha terminado correctamente "
  end

  desc "Inicializar referencia entry_indicators period"
  task entry_indicators_period: :environment do
    puts " Iniciado proceso "
    period = Period.take
    EntryIndicator.update_all(period_id: period.id)
    puts " Proceso finalizado"
  end

  desc "Añadir 0 a la izquierda a orden"
    task order: :environment do
     update_order("MainProcess")
     update_order("SubProcess")
     update_order("Indicator")
    puts "Actualizados correctamente"

    end

  desc "inicializar tipos de acumuladores"

  task total_indicator_types: :environment do
    it = Item.create!(item_type: "total_indicator_type", description: "No acumula", updated_by: "initialize")
    TotalIndicatorType.create(item_id: it.id, acronym: '-',order: 1, updated_at: 'initialize', active: TRUE)
    it = Item.create!(item_type: "total_indicator_type", description: "Acumula", updated_by: "initialize")
    TotalIndicatorType.create(item_id: it.id, acronym: 'A',order: 5, updated_at: 'initialize', active: TRUE)
    it = Item.create!(item_type: "total_indicator_type", description: "Entrada", updated_by: "initialize")
    TotalIndicatorType.create(item_id: it.id, acronym: 'E',order: 2, updated_at: 'initialize', active: TRUE)
    it = Item.create!(item_type: "total_indicator_type", description: "Salida", updated_by: "initialize")
    TotalIndicatorType.create(item_id: it.id, acronym: 'S',order: 3, updated_at: 'initialize', active: TRUE)
    it = Item.create!(item_type: "total_indicator_type", description: "Único", updated_by: "initialize")
    TotalIndicatorType.create(item_id: it.id, acronym: 'U',order: 4, updated_at: 'initialize', active: TRUE)
    puts "Inicializados correctamente"
  end

  desc "inicializar indicator_metric en indicator_sources"

  task indicator_sources: :environment do
    IndicatorMetric.all.each do |im|

     IndicatorSource.where(indicator_id: im.indicator).each do |is|
       is.indicator_metric_id = im.id
       is.save
      end
    end
  end

  task sub_process_order: :environment do
    SubProcess.all.each do |sp|
      sp.order = sp.order_char
      sp.save
    end
  end

  task create_metrics: :environment do
    [
        "Número de accesos controlados en los edificios cuya gestión está encomendada a esa Secretaría General Técnica a fecha 31 de diciembre del año.",
        "Número de edificios adscritos a Área de Gobierno a fecha 31 de diciembre del año.",
        "Número de empleados del Área de Gobierno a fecha 31 de diciembre del año.",
        "Número de contratos de arrendamiento de edificios gestionados por la Secretaría General Técnica a fecha 31 de diciembre del año.",
        "Número total de equipos informáticos a fecha 31 de diciembre del año.",
        "Número total de equipos de telefonía a fecha 31 de diciembre del año.",
        "Número de plazas de estacionamiento del  Área de Gobierno a fecha 31 de diciembre del año.",
        "Número de dependencias del Área de Gobierno a fecha 31 de diciembre del año.",
        "Número total de puestos de trabajo en RPT adscritos al Área de Gobierno a fecha 31 de diciembre del año.",
        "Número de empleados que ocupan puestos del Área de Gobierno a fecha 31 de diciembre del año, excepto los gestionados por centros directivos con competencias específicas (Policía Municipal, Bomberos y Emergencias)",
        "Número de empleados que ocupan puestos del Área de Gobierno a fecha 31 de diciembre del año",
        "Número de empleados con crédito horario a fecha 31 de diciembre del año.",
        "Número de  libros y revistas existentes en el fondo bibliográfico a fecha 31 de diciembre del año."
    ].each do |it|
      Metric.create(item: Item.create(item_type: 'metric', description: it))
    end
  end

  desc "inicializa la nuev atabla validations para un periodo"
  task validations: :environment do
    period_id = ENV['period'].to_i
    period = Period.find(period_id)
    period.organization_type.organizations.each do |organization|
      puts 'Procesando organización: ' + organization.description
      organization.units.each do |unit|
        validate_input(period, unit)
        puts '  - unidad: ' + unit.id.to_s + ' ' + unit.description_sap
      end
    end
  end
end

private

  def update_order(resource)
    Object.const_get(resource).all.each do |mp|
      if mp.order < 10
        mp.order = mp.order.to_s.rjust(2, '0')
        mp.save
      end
    end
  end

  def validate_input(period, unit)
    remove_last_validation(period, unit)
    last_update(period, unit)
    empty_indicators = validate_indicator_metrics(period, unit)

    create_validation(:incomplete_entry, period, unit, empty_indicators) if empty_indicators.present?
    data = AssignedEmployee.staff_for_unit(period, unit)
    create_validation(:assigned_staff,  period, unit, data) if data.present?
    data = Indicator.validate_staff_for_entry(period, unit)
    create_validation(:entry_without_staff, period, unit, data[0]) if data[0].present?
    create_validation(:staff_without_entry, period, unit, data[1]) if data[1].present?
    create_validation(:no_justification, period, unit ) if justification_blank(period, unit).present?

    input_errors = Validation.by_period(period.id).by_unit(unit.id)
    create_validation(:success_validation, period, unit) if input_errors.blank?
  end

  def create_validation(key, period, unit, data = '' )
    user = @last_update[1]
    update_at = @last_update[0]
    Validation.add(period, unit, key, I18n.t("entry_indicators.form.error.title.#{key}"),
                   I18n.t("entry_indicators.form.error.p1.#{key}_html"), data, user, update_at)
  end

  def remove_last_validation(period, unit)
    Validation.delete_all(period: period, unit: unit)
  end

  def last_update(period, unit)
    @last_update ||= unit.entry_indicators.period(period.id).order("updated_at DESC").pluck(:updated_at, :updated_by).first
  end

  def validate_indicator_metrics(period, unit)
    indicator_empty = []
    period.indicators(unit).each do |indicator_ar|
      indicator_ar.each do |indicator|
        indicator.indicator_metrics.each do |indicator_metric|
          indicator_empty.push(indicator.item.description) if indicator_metric.entry_indicators.empty?
        end
      end
    end
    indicator_empty
  end

  def justification_blank(period, unit)
    change = unit.assigned_employees_changes.by_period(period).by_unit(unit).take
    change.justification.blank? if change.present?
  end

