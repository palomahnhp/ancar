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

  task imported_sources: :environment do
    Source.where(item_id: Item.where(description: ["SIGSA", "SAP RRHH", "PLYCA", "SAP ECO FIN", "PLATEA", "Catálogo", "Inventario" ]).ids).
        map{|s| s.update_attribute(:imported, true)}
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

    def sources_imported
      return ["SIGSA", "SAP RRHH", "PLYCA", "SAP ECO FIN", "PLATEA", "Catálogo", "Inventario" ]
    end
  end
