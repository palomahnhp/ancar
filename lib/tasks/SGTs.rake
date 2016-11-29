namespace :SGT do
  require 'spreadsheet'

  desc "Importar datos de la SGT"
#  rake SGT:import file=/home/phn001/Documents/ANCAR/SGTs/DatosSGTs-2016-T1.xls period=78
  task :import => :environment do
    file = ENV['file'] or raise "Hay que indicar un fichero file=fichero"
    period_id = ENV['period'] or raise "Hay que indicar el id del periodo a cargar period=id"
    @updated_by = "import"
    @period = Period.exists?(period_id) ? Period.find(period_id) : nil
    if @period.nil?
      puts "No existe el periodo con id #{period_id}"
      exit
    end

    puts "Realizando carga de datos del fichero #{file} en el periodo #{@period.description} ..... "
    libro = Spreadsheet.open file
    hoja = libro.worksheet 0
        @unit_id_ant = ""
    @equivalencias = change_name
    (hoja.rows).each  do |row|
      if row.idx == 0
        columns_assignation(row)
      else
        process_row(row, row.idx)
      end
    end
    puts "Finalizada importación de datos de SGT."
  end

  private

  def process_row(row, idx)
    # unit & organization
    unit_id = row[@columns["ncodUni"]-1]
    unit_order= 1
    unit_description = row[@columns["cDenominacion"]-1]
    unit_description = @equivalencias[unit_description.to_sym]
    puts unit_description if @unit_id_ant != unit_id
    @unit_id_ant = unit_id
    @unit_type = UnitType.find_or_create_by(organization_type_id: @period.organization_type.id,
                                            description: "Secretarías Generales Técnicas")

    @organization = @period.organization_type.organizations.find_or_create_by(
      description: unit_description)
    if @organization.changed?
      @organization.updated_by =   @updated_by
      @organization.save
    end

    @unit = @organization.units.find_or_create_by(sap_id: unit_id,
                             description_sap: unit_description,
                             unit_type_id: @unit_type.id, order: unit_order)
    if @unit.changed?

      @unit.updated_by =   @updated_by
      @unit.save
    end


    # main_process
    process_order = row[@columns["Bloque_orden"]-1]
    process_description = row[@columns["Bloque_descripcion"]-1]

    proceso = @period.main_processes.find_or_create_by(
      item_id: Item.find_or_create_by(item_type: "main_process",
      description: process_description).id )
    proceso.order = process_order.to_s.rjust(2, '0')  # => '05'
    proceso.updated_by = @updated_by
    proceso.save


    # sub_process
    subprocess_order = row[@columns["Proceso_orden"]-1]
    subprocess_description = row[@columns["Proceso_descripcion"]-1]

    subproceso = proceso.sub_processes.find_or_create_by(
        item_id: Item.find_or_create_by(item_type: "sub_process", description: subprocess_description).id,
        unit_type_id: @unit_type.id)
    subproceso.order = subprocess_order.to_s.rjust(2, '0')
    subproceso.updated_by = @updated_by
    subproceso.save


    # indicator
    indicator_order = 0
    indicador = row[@columns["tareas"]-1]
    metrica = row[@columns["vTodoTareaIndicadorSGT.descripcion"]-1]
    fuente = row[@columns["Fuente.descripcion"]-1]
    fuenteTexto = row[@columns["fuenteTexto"]-1]
    task = subproceso.tasks.find_or_create_by(item_id: Item.find_or_create_by(item_type: "task", description: "Tarea").id)
    indicator_item = indicador[0..100]

    indicator = task.indicators.find_or_create_by(item_id: Item.find_or_create_by(
      item_type: "indicator", description: indicator_item ).id, description: indicador)


    indicator.updated_by = @updated_by
    indicator.order = indicator_order.to_s.rjust(2, '0')
    indicator.save

    it = Item.find_or_create_by(item_type: "metric", description: metrica)
    metric = Metric.find_or_create_by(item_id: it.id)
    metric.save
    it = Item.find_or_create_by(item_type: "source", description: fuente)
    source = Source.find_or_create_by(item_id: it.id, updated_by: @updated_by)
    source.save

    indicator_metric = indicator.indicator_metrics.find_or_create_by(metric_id: metric.id)
    indicator_source = indicator.indicator_sources.find_or_create_by(source_id: source.id)

    # entry_indicators
    cantidad = row[@columns["cantidad"]-1]
    grupo= []
    grupo << row[@columns["A1"]-1]
    grupo << row[@columns["A2"]-1]
    grupo << row[@columns["C1"]-1]
    grupo << row[@columns["C2"]-1]

    agrupacion = row[@columns["agrupacion"]-1]

    amount = cantidad.to_i
    entry_indicator = EntryIndicator.find_or_create_by(unit_id: @unit.id, indicator_metric_id: indicator_metric.id)
    entry_indicator.specifications = fuenteTexto
    entry_indicator.amount = amount
    entry_indicator.period_id = @period.id
    entry_indicator.updated_by = @updated_by
    entry_indicator.save
    OfficialGroup.all.each.with_index do |og, index|
      ae = AssignedEmployee.find_or_create_by(official_group_id: og.id,
        staff_of_type: "sub_process", staff_of_id: subproceso.id,
        period_id: @period.id, unit_id: @unit.id)

      ae.quantity = grupo[index]
      ae.updated_by = @updated_by
      ae.save
    end
  end

  def columns_assignation(row)
    cols = row.to_a
    i = 0
    @columns = Hash[cols.map {|key, value| [key, i+= 1]}]
  end

  def change_name
    {
      "PJG SGT PORTAV. COORD. J.G. RR CON PLENO" => "SECRETARIA GENERAL TECNICA PORTAVOZ COORDINACION DE LA J. G. Y RELACIONES PLENO",
      "AGU SGT DESARROLLO URBANO SOSTENIBLE" => "SECRETARIA GENERAL TECNICA DEL AREA DE GOBIERNO DE DESARROLLO URBANO SOSTENIBLE",
      "AGM SGT AG MEDIO AMBIENTE Y MOVILIDAD" => "SECRETARIA GENERAL TECNICA AG MEDIO AMBIENTE Y MOVILIDAD",
      "AGS SGT AG SALUD,SEGURIDAD Y EMERGENCIAS" => "SECRETARIA GENERAL TECNICA A.G. SALUD, SEGURIDAD Y EMERGENCIAS",
      "GC SGT GERENCIA DE LA CIUDAD" => "SECRETARIA GENERAL TECNICA GERENCIA DE LA CIUDAD",
      "AGF SGT EQUIDAD, DCHOS SOCIALES Y EMPLEO" => "SECRETARIA GENERAL TECNICA DE EQUIDAD DERECHOS SOCIALES Y EMPLEO",
      "AGA SGT CULTURA Y DEPORTES" => "SECRETARIA GENERAL TECNICA AREA DE GOBIERNO DE CULTURA Y DEPORTES",
      "AGE SGT ECONOMIA Y HACIENDA" => "SECRETARIA GENERAL TECNICA AREA DE GOBIERNO DE ECONOMIA Y HACIENDA"
    }
  end
end