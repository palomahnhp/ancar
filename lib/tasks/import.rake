namespace :import do
  require 'spreadsheet'
=begin
  Tiene dos tareas:
  -  - DISTRITO:
         IMPORTACIÓN INICIAL DE DATOS GENERALES Y DATOS DE ENTRADA DE DISTRITOS
         Entrada: excel de cada distrito 99999999_distrito.xls 99999999 -> id de SAP del distrito.
     - UNIDADES:
         Carga inicial del organigrama de Distrito obtenidos de Directorio
=end

  desc "Import organizations data"
  task indicadores: :environment do

    Dir["../CargasDistritos/*"].each do |file|
      libro = Spreadsheet.open file
      @sap_id = File.basename(file)[0,8]

      @first_time = true
      @deb = false
      puts "************* #{file} ************ "
    # Procesando las hojas de los departamentos
      (3..11).each do |i|
         hoja = libro.worksheet i
         process_sheet(hoja, file)
       end
    end
  end

  desc "import units"
  task distritos: :environment do
#    Rake::Task["db:seed"].execute
    file_name = "../UnidadesDistritos.xls"
    libro = Spreadsheet.open file_name

    # Procesando las hojas de los departamentos
    (0..8).each do |i|
       hoja = libro.worksheet i
       @num = 0
       process_units(hoja, i)
       puts "Creando: #{hoja.name} - nº: #{@num}"
     end
   end
end

private
  def process_units(hoja, i)
    @organization_type = OrganizationType.where(description: 'Distritos').first
    (hoja.rows).each  do |f|
      next if f[1].nil? || f[1] == "DIRECCIÓN" || f[1] == "COD. UNIDAD" # no procesa fila 1, cabecera
      @id_sap = f[1]
      @nombre = f[2]
      @JM_id_sap = f[8]
      @JM_nombre = f[9]
      create_unit(hoja.name, i)
    end
  end

  def create_unit(name, i )
    if @JM_id_sap # departamentos
      ut = UnitType.where(description: name).first
 #     puts "  Creado Dpto #{@nombre} "
      @num += 1
      if ut.nil?
        puts UnitType.all.pluck(:description)
        raise "Error buscando tipo unidad #{@sap_id} #{name}"
      end
      o = Organization.where(sap_id: @JM_id_sap).first
      u = Unit.create!(unit_type_id: ut.id, organization_id: o.id, description_sap: @nombre, sap_id: @id_sap, order: ut.order)
    else # JM
       o = Organization.create!(organization_type_id: @organization_type.id, description: @nombre, sap_id: @id_sap)
#       puts "  Creada JM #{@nombre}"
      @num += 1
       @JM_id_sap = @JM_nombre = nil
    end
  end

  def process_sheet(hoja, file_name)
    n = hoja.rows.count
    reset_vars
    if (hoja.name.include? "Hoja")
      return
    end
    if (hoja.name.downcase.include? "ncidencia")
      return
    end
    puts "== #{hoja.name} =="
    # Procesando cabecera de la hoja
    if @first_time
      @organization_type = "Distritos"
      @cell_period = hoja.row(2)[1]
      get_period_organization
    end

    @cell_unit_type =  hoja.row(3)[1]

    get_unit
    @cell_efectivos_proc = { "A1": hoja.row(6)[7], "A2": hoja.row(6)[8],
                             "C1": hoja.row(6)[9], "C2": hoja.row(6)[10],
                             "E":  hoja.row(6)[11] }
    treat_proc("staff_unit", 0)

    @cell_dedicacion_proc = { "A1": hoja.row(7)[7], "A2": hoja.row(7)[8],
                              "C1": hoja.row(7)[9], "C2": hoja.row(7)[10],
                              "E":  hoja.row(7)[11] }
    (hoja.rows).each do |f|
      cols = f.count

      case
      when !f[0].nil? then #MainProcess
        import_process('main_process', f[1])
       when !f[2].nil? then # subprocess
        import_process('sub_process', f[3])
        # En el caso de los distritos la tarea es única y no viene en el csv
        import_process('task', 'Tarea')
      when  f[3] == 'TOTAL  SUBPROCESO' then # efectivos subprocess

        @cell_efectivos_sub_proc = { "A1": process_cell(f[7]),
                              "A2": process_cell(f[8]),
                              "C1": process_cell(f[9]),
                              "C2": process_cell(f[10]),
                              "E":  procaess_cell(f[11]) }

        treat_proc("staff", 0)

      when  !f[3].nil? && f[3] != 'TOTAL  SUBPROCESO' # indicator
        @cell_metric = f[4]
        @cell_source = f[5]
        if f[6].class.to_s == 'Spreadsheet::Formula'
          @cell_amount = f[6].value
        elsif f[6].class.to_s  == 'Fixnum' || f[6].class.to_s  == 'Float'
          @cell_amount =  f[6]
        else
          @cell_amount = 0
        end
        import_process('indicator', f[3])
      end
    end
  end

  def get_period_organization
    @first_time = false
    @ot = OrganizationType.where(description: @organization_type).first
    if @ot
       puts "OrganizationType:   #{@ot.description}"
    else
      raise "Error: Tipo de organización no encontrada: #{@organization_type}"
    end

    @per = Period.where(organization_type_id: @ot.id, description: @cell_period).first
    if @per
       puts "PERIODO: #{@per.description} "
    else
      raise "ERROR: Periodo no encontrado: #{@cell_period}"
    end

    @o = Organization.where(sap_id: @sap_id).first
    if @o
       puts "ORGANIZATION:       #{@o.description}"
    else
      raise "Error: Organización no encontrada: #{@cell_organization}"
    end
    @cell_period =  @cell_organization_type =  @cell_organization = nil
  end

  def get_unit
    @unit_type_description = convert_om(@cell_unit_type)
    @ut = UnitType.where(description: @unit_type_description).first
    if @ut
       puts "UNIT_TYPE:          #{@ut.description}"
    else
      raise "Error: Tipo de unidad no encontrada: #{@cell_unit_type} #{@sap_id}"
    end

    @u = Unit.where(unit_type_id: @ut.id, organization_id: @o.id).first
    if @u
#      # puts "UNIT: #{@u.description_sap}"
    else
      debugger
      raise "Error: Unidad no encontrada: #{@cell_unit_type} #{@sap_id}"
    end
    @cell_unit_type  = @cell_unit = nil
  end

  def import_process(type, description)
    if description.nil? then description = "" end
    description.strip! # Elimina blancos
    item = Item.where(item_type: type, description: description)
    if !item.empty? # existe item
      it = item.first
    else # se crea item
      it = Item.create!(item_type: type, description: description, updated_by: "import")
    end

    if description == ""
      # puts "ERROR - Description a blancos id #{it.id}"
    end

    treat_proc(type, it.id)
  end

  def treat_proc(type, id)
    case type
    when "main_process"
      stats("main_process")
      @mp = MainProcess.where(period_id: @per.id, item_id: id, updated_by: "import").first
      if @mp.nil?
        o_max = MainProcess.maximum(:order)
        o_max = o_max.nil?  ? 1 : (o_max + 1)
        @mp = MainProcess.create!(period_id: @per.id, item_id: id,
                                order:o_max, updated_by: "import")
      end
       puts "\n  MP: #{@mp.item.description}"
      @num_main_process += 1

    when "sub_process"
      stats("sub_process")
      o_max = SubProcess.maximum(:order)
      o_max = o_max.nil?  ? 1 : (o_max + 1)
      @sp = SubProcess.where(unit_type_id: @ut.id, main_process_id: @mp.id,
                             item_id: id, updated_by: "import").first
      if @sp.nil?
        @sp = SubProcess.create!(unit_type_id: @ut.id,
                    main_process_id: @mp.id, item_id: id, order:o_max, updated_by: "import")
      end
      puts "\n    SP: #{@sp.item.description}"
      @num_sub_process += 1

    when "task"
      @tk = Task.where(sub_process_id: @sp.id, item_id: id, updated_by: "import").first
      if @tk.nil?
        o_max = Task.maximum(:order)
        o_max = o_max.nil?  ? 1 : (o_max + 1)
        @tk = Task.create!(sub_process_id: @sp.id, item_id: id,  order:o_max, updated_by: "import")
      end

    when "indicator" # Por defecto se cargan de salida, y si es necesario se modifican por la app
        @ind = Indicator.where(task_id: @tk.id, item_id:id).first
      if @ind.nil?
        o_max = Indicator.maximum(:order)
        o_max = o_max.nil?  ? 1 : (o_max + 1)
        @ind = Indicator.create!(task_id: @tk.id, item_id:id, order: o_max, updated_by: "import")
      end
      import_process('metric', @cell_metric)
      @im = IndicatorMetric.where(indicator_id: @ind.id, metric_id: @mt.id).first
      if @im.nil?
        @im = IndicatorMetric.create!(indicator_id: @ind.id, metric_id: @mt.id)
      end

      import_process('source', @cell_source)

      @is = IndicatorSource.where(indicator_id: @ind.id, source_id: @sr.id).first
      if @is.nil?
        @is = IndicatorSource.create!(indicator_id: @ind.id, source_id: @sr.id)
      end

      @ei = EntryIndicator.create!(unit_id: @u.id, indicator_metric_id: @im.id, specifications: nil, amount: @cell_amount, updated_by: "import")
      puts "      IND: #{@ind.item.description } / Mt: #{@mt.item.description } - #{@mt.in_out}- #{@cell_amount} / Sr: #{@sr.item.description }"
      @cell_metric = @cell_source = nil
      @num_indicators += 1
      @tot_indicators =  @tot_indicators + @cell_amount

    when "metric"
      @mt = Metric.where(item_id: id).first
      if @mt.nil?
        in_out = in_out(@ut.description, @ind.item.description, Item.find(id).description)
        @mt = Metric.create!(item_id: id, in_out: in_out, updated_by: "import")
      end

    when "source"
      @sr = Source.where(item_id: id, fixed: true, has_specification: false, updated_by: "import").first
      if @sr.nil?
        @sr = Source.create!(item_id: id, fixed: true, has_specification: false, updated_by: "import")
      end

    when "staff"
      @cell_efectivos_sub_proc.each do |group, quantity|
        gr = OfficialGroup.where(name: group).first
        @ae = AssignedEmployee.create!(staff_of_id: @sp.id, staff_of_type: "SubProcess", official_groups_id: gr.id,
          quantity: quantity, updated_by: "import")
         print "      Staff : #{group} #{quantity} "
      end

      @cell_efectivos_sub_proc = false
    when "staff_unit"
      @cell_efectivos_proc.each do |group, quantity|
        gr = OfficialGroup.where(name: group).first
        @ae = AssignedEmployee.create!(staff_of_id: @sp.id, staff_of_type: "Unit", official_groups_id: gr.id,
          quantity: quantity, updated_by: "import")
         print "      Staff : #{group} #{quantity} "
      end

      @cell_efectivos_sub_proc = false
    end #end case
  end

  def convert_om(unit_type_description)
    # Se igual el nombre de las hojas con indicadores con el de EOM
    if unit_type_description.nil? then
      debugger
      unit_type_description = ""
    end
    unit_type_description.strip! # Elimina blancos
    case  unit_type_description
    when "DEPARTAMENTO DE SERVICIOS JURÍDICOS" then
      "DEPARTAMENTO DE SERVICIOS JURIDICOS"
    when "DEPARTAMENTO DE SERVICIOS TÉCNICOS" then
      "DEPARTAMENTO DE SERVICIOS TECNICOS"
    when "DEPARTAMENTO DE SERVICIOS ECONÓMICOS" then
      "DEPARTAMENTO DE SERVICIOS ECONOMICOS"
    when "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS"
      "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS"
    when "SECCIÓN DE EDUCACIÓN" then
      "SECCION DE EDUCACION"
    when  "DEPARTAMENTO DE SERVICIOS SOCIALES" then
      "DEPARTAMENTO DE SERVICIOS SOCIALES"
    when "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO" then
      "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO"
    when "SECRETARÍA DEL DISTRITO" then
      "SECRETARIA DE DISTRITO"
    end
  end

  def stats(tipo)
    case tipo
    when "unit"
        # puts "  Efectivos: #{@staff}"
        # puts "  Procesos: #{@num_main_process}"
    when "main_process"
        # puts "  Subprocesos: #{@num_sub_process}"
    when "sub_process"
       puts "  Efectivos: #{@staff}"
       puts "  Indicadores: #{@num_indicators} total: #{@tot_indicators}"
    end
  end

  def in_out(unit_type, indicador, metrica)
    unit_type.strip! # Elimina blancos

    if unit_type == "DEPARTAMENTO DE SERVICIOS JURIDICOS"
      case
      when indicador == "Contratos derivados del acuerdo Marco" && metrica == "nº de expedientes"
         in_out = "out"
      when metrica == "nº de contratos NO DE Acuerdos Marco"
         in_out = "out"
      when indicador == "Convenio" && metrica == "nº Convenios"
         in_out = "out"
      end

    elsif  unit_type == "DEPARTAMENTO DE SERVICIOS ECONOMICOS"
      in_out = "in"
      case
      when indicador == "Seguimiento facturación" && metrica == "nº facturas"
         in_out = "out"
      when metrica == "nº de contratos NO DE Acuerdos Marco"
         in_out = "out"
      when indicador == "Documentos contables"
         in_out = "stock"
      when indicador == "Revisiones de precios"
         in_out = "stock"
      when indicador == "Reajuste de anualidades"
         in_out = "stock"
      when indicador == "Liquidación de contratos"
         in_out = "stock"
      when indicador == "Devolución de garantías"
         in_out = "stock"

      end
    end
    return in_out
  end

  def reset_vars
    @staff = 0
    @num_main_process = 0
    @num_sub_process = 0
    @tot_sub_process = 0
    @tot_indicators = 0
    @num_indicators = 0
  end

  def process_cell(value)
    case
    when value.nil?
      0
    when value.class_to_s == "Spreadsheet::Formula"
      value.value
    else
      value
    end
  end
