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

  desc "Import process structure"
  task procesos: :environment do
    file = "../procesos_distritos_2015.xls"
    libro = Spreadsheet.open file
    @first_time = true
    @deb = false
    @process_structure = true
    init_log
    cab_log
    init_log
    clear_data
    (10000002..10000002).each  do |o|
    # Procesando las hojas de los departamentos
      @sap_id = o
      (3..11).each do |i|
         hoja = libro.worksheet i
         process_sheet(hoja, file)
       end
     end
     puts "Finalizada importación de procesos de distritos"
  end

  desc "Import organizations entry data"
  task indicadores: :environment do
      init_log
      cab_log
    Dir["../CargasDistritos/*"].each do |file|
      libro = Spreadsheet.open file
      @sap_id = File.basename(file)[0,8]
      @first_time = true
      @deb = false

#     @hash_log = Hash.new(" ")
#      @hash_log[:distrito] = file
    # Procesando las hojas de los departamentos
      (3..10).each do |i|
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
#       puts UnitType.all.pluck(:description)
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
    @observaciones = ""
    reset_vars
    if (hoja.name.include? "Hoja")
      return
    end
    if (hoja.name.downcase.include? "ncidencia")
      return
    end
#    @hash_log[:distrito] = "\n#{hoja.name}"
    # Procesando cabecera de la hoja
    if @first_time
      @organization_type = "Distritos"
      @cell_period = hoja.row(2)[1]
      get_period_organization
    end

    @cell_unit_type =  hoja.row(3)[1]
    get_unit

    if !@process_structure
      @cell_efectivos_unit = { A1: process_cell(hoja.row(7)[7]),
                               A2: process_cell(hoja.row(7)[8]),
                               C1: process_cell(hoja.row(7)[9]),
                               C2: process_cell(hoja.row(7)[10]),
                               E:  process_cell(hoja.row(7)[11])}
      treat_proc("staff_unit", 0, "")

=begin      @hash_log[:u_A1] = @cell_efectivos_unit[:A1] unless @process_structure
      @hash_log[:u_A2] = @cell_efectivos_unit[:A2] unless @process_structure
      @hash_log[:u_C1] = @cell_efectivos_unit[:C1] unless @process_structure
      @hash_log[:u_C2] = @cell_efectivos_unit[:C2] unless @process_structure
      @hash_log[:u_E] = @cell_efectivos_unit[:E] unless @process_structure

=end
@cell_dedicacion_proc = { A1: hoja.row(8)[7], A2: hoja.row(8)[8],
                                C1: hoja.row(8)[9], C2: hoja.row(8)[10],
                                E:  hoja.row(8)[11] }
    end

    (hoja.rows).each do |f|

      next if  f.idx.between?(0,5)
      cols = f.count

      case
      when !f[0].nil? && (f[0].is_a? Numeric) then #MainProcess
        import_process('main_process', f[1])
       when !f[2].nil? then # subprocess
        import_process('sub_process', f[3])
        # En el caso de los distritos la tarea es única y no viene en el csv
        import_process('task', 'Tarea')
      when  f[3] == 'TOTAL  SUBPROCESO' then # efectivos subprocess

        if !@process_structure
         @cell_efectivos_sub_proc = { A1: process_cell(f[7]),
                                A2: process_cell(f[8]),
                                C1: process_cell(f[9]),
                                C2: process_cell(f[10]),
                                E:  process_cell(f[11]) }

=begin          @hash_log[:sp_A1] = @cell_efectivos_sub_proc[:A1] unless @process_structure
          @hash_log[:sp_A2] = @cell_efectivos_sub_proc[:A2] unless @process_structure
          @hash_log[:sp_C1] = @cell_efectivos_sub_proc[:C1] unless @process_structure
          @hash_log[:sp_C2] = @cell_efectivos_sub_proc[:C2] unless @process_structure
          @hash_log[:sp_E] = @cell_efectivos_sub_proc[:E] unless @process_structure
=end
          treat_proc("staff", 0, "")
        end
      when  !f[3].nil? && f[3] != 'TOTAL  SUBPROCESO' # indicator
        @cell_metric = f[4]
 #       @hash_log[:metrica] = @cell_metric unless @process_structure
        @cell_source = f[5]
        if f[6].class.to_s == 'Spreadsheet::Formula'
          @cell_amount = f[6].value
        elsif f[6].class.to_s  == 'Fixnum' || f[6].class.to_s  == 'Float'
          @cell_amount =  f[6]
        else
          @cell_amount = 0
        end
#        @hash_log[:cantidad] = @cell_metric unless @process_structure
        import_process('indicator', f[3])
      end
    end

  end

  def get_period_organization

    @first_time = false
    @ot = OrganizationType.where(description: @organization_type).first
    if @ot
#       puts "OrganizationType:   #{@ot.description}"
    else
      raise "Error: Tipo de organización no encontrada: #{@organization_type}"
    end

    @per = Period.where(organization_type_id: @ot.id, description: @cell_period).first
    if @per
#       puts "PERIODO: #{@per.description} "
    else
      raise "ERROR: Periodo no encontrado: #{@cell_period}"
    end
    @o = Organization.where(sap_id: @sap_id).first
    if @o
       puts @o.description
    else
      raise "Error: Organización no encontrada: #{@cell_organization}"
    end
    @cell_period =  @cell_organization_type =  @cell_organization = nil
  end

  def get_unit
    @unit_type_description = convert_om(@cell_unit_type)
    @ut = UnitType.where(description: @unit_type_description).first

    if @ut
 #    puts "UNIT_TYPE:          #{@ut.description}"
    else
      write_log("*** ERROR: Tipo de unidad no encontrada: #{@cell_unit_type} #{@sap_id}")
      raise "Error: Tipo de unidad no encontrada: #{@cell_unit_type} #{@sap_id}"
    end
    if @o.nil?
      raise "Error: organización a nulos"
    end
    @u = Unit.where(unit_type_id: @ut.id, organization_id: @o.id).first
    if @u
#      # puts "UNIT: #{@u.description_sap}"
    else
      write_log("*** ERROR: Unidad no encontrada: #{@cell_unit_type} #{@sap_id}")
      raise "Error: Unidad no encontrada: #{@cell_unit_type} #{@sap_id}"
    end
    @cell_unit_type  = @cell_unit = nil
  end

  def import_process(type, description)
    if description.nil? then description = "" end
    description = convert_string(type, description)
    if description == ""
      write_log("*** ERROR - Description a blancos id #{type}")
    end

    item = Item.where(item_type: type, description: description)
    if item.empty? # NO existe item
      if @process_structure # se crea item solo oen proceso de estructura
        it = Item.create!(item_type: type, description: description, updated_by: "import")
      else
         write_log("*** ERROR: #{type} #{description} no existe", "sub_process")
      end
    else
      it = item.first
    end
    if !it.nil?
      treat_proc(type, it.id, description)
    end
  end

  def treat_proc(type, id, description)
    case type
    when "main_process"
      stats("main_process")
      @mp = MainProcess.where(period_id: @per.id, item_id: id, updated_by: "import").first
      if @mp.nil?
        if @process_structure # se crea item solo en proceso de estructura
          o_max = MainProcess.maximum(:order)
          o_max = o_max.nil?  ? 1 : (o_max + 1)
          @mp = MainProcess.create!(period_id: @per.id, item_id: id,
                                  order:o_max, updated_by: "import")
        else
          write_log("*** ERROR: MainProcess no existe ", "main_process")
        end
      end
      @num_main_process += 1

    when "sub_process"
      stats("sub_process")
      o_max = SubProcess.maximum(:order)
      o_max = o_max.nil?  ? 1 : (o_max + 1)
      @sp = SubProcess.where(unit_type_id: @ut.id, main_process_id: @mp.id,
                             item_id: id, updated_by: "import").first
      if @sp.nil?
        if @process_structure # se crea item solo en proceso de estructura
          @sp = SubProcess.create!(unit_type_id: @ut.id,
                      main_process_id: @mp.id, item_id: id, order:o_max, updated_by: "import")
        else
          write_log("*** ERROR: SubProcess no existe: #{@¢ell_sub_process}, proceso: @mp.item.description ", "sub_process")
        end
      end

      @num_sub_process += 1

    when "task"
      if @sp
        @tk = Task.where(sub_process_id: @sp.id, item_id: id, updated_by: "import").first
      end
      if @tk.nil?
        o_max = Task.maximum(:order)
        o_max = o_max.nil?  ? 1 : (o_max + 1)
        @tk = Task.create!(sub_process_id: @sp.id, item_id: id,  order:o_max, updated_by: "import")
      end

    when "indicator" # Por defecto se cargan de salida, y si es necesario se modifican por la app
        @ind = Indicator.where(task_id: @tk.id, item_id:id).first
      if @ind.nil?
        if @process_structure # se crea item solo en proceso de estructura
          o_max = Indicator.maximum(:order)
          o_max = o_max.nil?  ? 1 : (o_max + 1)
          @ind = Indicator.create!(task_id: @tk.id, item_id:id, order: o_max, updated_by: "import")
        else
          write_log("*** ERROR: Indicator no existe #{@tk.item.description}", "Indicador")
        end
      end

      import_process('metric', @cell_metric)
      if @ind && @mt
        @im = IndicatorMetric.where(indicator_id: @ind.id, metric_id: @mt.id).first
      end
      if @im.nil?
        if @process_structure # se crea item solo en proceso de estructura
          @im = IndicatorMetric.create!(indicator_id: @ind.id, metric_id: @mt.id)
        else
          write_log("*** ERROR: IndicatorMetric no existe @ind.item.description @mt.item.description")
        end
      end

      import_process('source', @cell_source)
 #     @hash_log[:cantidad] = @cell_amount unless @process_structure
      if @ind && @sr
        @is = IndicatorSource.where(indicator_id: @ind.id, source_id: @sr.id).first
        if @is.nil?
          if @process_structure # se crea item solo en proceso de estructura
            @is = IndicatorSource.create!(indicator_id: @ind.id, source_id: @sr.id)
          end
        end
      end
      if @is && @u && @im
        @ei = EntryIndicator.create!(unit_id: @u.id, indicator_metric_id: @im.id, specifications: nil, amount: @cell_amount, updated_by: "import")
      end
      @cell_metric = @cell_source = nil
      @num_indicators += 1
      @tot_indicators =  @tot_indicators + @cell_amount

    when "metric"
      @mt = Metric.where(item_id: id).first
      if @mt.nil?
        if @process_structure # se crea item solo en proceso de estructura
          @mt = Metric.create!(item_id: id, in_out: "in", updated_by: "import")
        else
          write_log("*** ERROR: Metric no existe  #{Item.find(id).description}", "Métrica")
        end
      end
    when "source"
      @sr = Source.where(item_id: id, fixed: true, has_specification: false, updated_by: "import").first
      if @sr.nil?
        if @process_structure # se crea item solo en proceso de estructura
          @sr = Source.create!(item_id: id, fixed: true, has_specification: false, updated_by: "import")
         else
        write_log("*** ERROR: fuente no existe #{Item.find(id).description}", "Fuente")
        end
      end

    when "staff"
      @cell_efectivos_sub_proc.each do |group, quantity|
        gr = OfficialGroup.where(name: group).first
        if @sp
          @ae = AssignedEmployee.create!(staff_of_id: @sp.id, staff_of_type: "SubProcess", official_groups_id: gr.id,
            quantity: quantity, updated_by: "import")
           # print "      Staff : #{group} #{quantity} "
        end
      end

      @cell_efectivos_sub_proc = false
    when "staff_unit"

      if !@process_structure
        @cell_efectivos_unit.each do |group, quantity|
          gr = OfficialGroup.where(name: group).first
          @ae = AssignedEmployee.create!(staff_of_id: @u.id, staff_of_type: "Unit", official_groups_id: gr.id,
            quantity: quantity, updated_by: "import")
           # print "      Staff : #{group} #{quantity} "
        end
      end
      @cell_efectivos_sub_proc = false
    end #end case
     write_log(@observaciones) unless @observaciones == ""
      @observaciones = ""
  end

  def convert_string(type, description)
  # if description["Quioscos"] then debugger end
   description.strip! if description.is_a?(String) # Elimina blancos

      description = "" if description.nil?

      if description.is_a?(String)
        if type =='indicator' && !@mp.nil? && @mp.item.description ==
          'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)'
          description  = '** CORRECCIÓN: SE OMITE - indicador de otros procesos'
        end
        if description["\n"]
         description.gsub!(/\n/, "")
         #description["\n"] =  ""
        @observaciones << "** CORRECCIÓN: Eliminado retorno carro #{description}"

        end
        # description["\n"] = ""  if description["\n"] # Elimina \n
        if description["  "] # dos espacios
          description.gsub!(/"  "/, " ")
         #description["  "] = " "

          @observaciones << "** CORRECCIÓN: Eliminado doble blanco #{description}"
        end

        # description["  "] = " " if description["  "] # dos espacios
        if description[";"]
          description.gsub(/";"/, ",")
        #  description[";"] = ","

          @observaciones << "** CORRECCIÓN: Sustituido punto y como por , #{description}"
        end
        # description[";"] = ","  if description[";"]  # Elimina ;

      if !@process_structure
        case description
        when 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS'
          description = "OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS"
          @observaciones << "** CORRECCIÓN: -OTROS PROCESOS DEPARTAMENTO DE SERVICIOS- por - OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS-"

        when 'Situados (Quioscos Prensa, Flores, etc.) (se indican únicamente las solicitudes presentadas para dos puestos vacantes de pintores, el resto de los situados tiene autorización para 15 años'
          description = "Situados (Quioscos Prensa, Flores, etc.)"

          @observaciones << "** CORRECCIÓN: - Situados (Quioscos Prensa, Flores, etc.) (se indican únicamente las solicitudes presentadas para dos puestos vacantes de pintores, el resto de los situados tiene autorización para 15 años - por - Situados (Quioscos Prensa, Flores, etc.) - "

        when "Expedición de documentos de licencias (se incluye documento comunicación previa correcta que se envía al interesado)"
          description = 'Expedición de documentos de licencias'
          @observaciones << "** CORRECCIÓN: - Expedición de documentos de licencias (se incluye documento comunicación previa correcta que se envía al interesado) -  por - Expedición de documentos de licencias - "

        when 'Total de Autorizaciones de uso de espacios y vías públicas solicitadas y pendientes de resolver al 1 de enero de 2015'
          description = "Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015"
          @observaciones << "** CORRECCIÓN: - Total de Autorizaciones de uso de espacios y vías públicas solicitadas y pendientes de resolver al 1 de enero de 2015 - por - Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015 - "

        when 'Total de Autorizaciones de uso de espacios y vías públicas solicitadas y pendientes  de resolver  al 1 de enero de 2015'
          description = "Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015"
          @observaciones << "** CORRECCIÓN: - Total de Autorizaciones de uso de espacios y vías públicas solicitadas y pendientes  de resolver  al 1 de enero de 2015 - por - Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015 - "


        when 'Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015'
          description = "Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015"
          @observaciones << "** CORRECCIÓN: - Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015 - por - Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015 - "

        when 'Expedientes pendientes  a 1 de enero de 2015'
          description = "Expedientes pendientes  a 1 de enero de 2015"
          @observaciones << "** CORRECCIÓN: - Expedientes pendientes  a 1 de enero de 2015 - por - Expedientes pendientes a 1 de enero de 2015  - "

        when 'Expedientes pendientes a 1 de enero de 2015 '
          description = "Expedientes pendientes  a 1 de enero de 2015"
          @observaciones << "** CORRECCIÓN: - Expedientes pendientes a 1 de enero de 2015  - por - Expedientes pendientes a 1 de enero de 2015  - "

        when 'Expedientes pendientes a 1 de enero de 2015'
          description = "Expedientes pendientes  a 1 de enero de 2015"
          @observaciones << "** CORRECCIÓN: - Expedientes pendientes a 1 de enero de 2015 - por - Expedientes pendientes a 1 de enero de 2015  - "

        when 'Renovación de Terrazas y Veladores'
          description = "Renovaciones de Terrazas y Veladores"

          @observaciones << "** CORRECCIÓN: - Renovación de Terrazas y Veladores - por - Renovaciones de terrazas y veladores - "

        when 'Renovaciones de terrazas de veladores'
          description = "Renovaciones de Terrazas y Veladores"

          @observaciones << "** CORRECCIÓN: - Renovaciones de terrazas de veladores - por - Renovaciones de terrazas y veladores - "

        when 'Renovaciones de terrazas y veladores.'
          description = "Renovaciones de Terrazas y Veladores"

          @observaciones << "** CORRECCIÓN: - Renovaciones de terrazas y veladores. - por - Renovaciones de terrazas y veladores- "

        when 'Renovacion de terrazas y veladores'
          description = "Renovaciones de Terrazas y Veladores"

          @observaciones << "** CORRECCIÓN: - Renovaciones de terrazas y veladores. - por - Renovaciones de Terrazas y Veladores- "

        when 'Renovaciones Terrazas y Veladores'
          description = "Renovaciones de Terrazas y Veladores"

          @observaciones << "** CORRECCIÓN: - Renovaciones Terrazas y Veladores - por - Renovaciones de terrazas de veladores - "

        when 'Renovaciones Terrazas'
          description = "Renovaciones de Terrazas y Veladores"
          @observaciones << "** CORRECCIÓN: - Renovaciones Terrazas - por - Renovaciones de terrazas de veladores - "

        when 'Expedientes sancionadores no urbanísticos'
          description = "Expedientes sancionadores no urbanísticos (incluye terrazas y veladores)"

          @observaciones << "** CORRECCIÓN: - Expedientes sancionadores no urbanísticos - por - Expedientes sancionadores no urbanísticos (incluye terrazas y veladores)- "

        when 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS'
          description = "OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS"

          @observaciones << "** CORRECCIÓN: - OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS - por - OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS - "


        when 'SERVICIO (acuerdo marco y gestion integral)'
          description = "SERVICIO"

          @observaciones << "** CORRECCIÓN: - SERVICIO (acuerdo marco y gestion integral) - por - SERVICIO - "

        when 'Autorizaciones demaniales y cesión de espacios públicos *'
          description = "Autorizaciones demaniales y cesión de espacios públicos"

          @observaciones << "**  CORRECCIÓN: Autorizaciones demaniales y cesión de espacios públicos * - por - Autorizaciones demaniales y cesión de espacios públicos - "

        when 'Unidad gestora Web *'
          description = "Unidad gestora Web"

          @observaciones << "**  CORRECCIÓN: Unidad gestora Web * - por - Unidad gestora Web - "

        when 'Contratos Menores*'
          description = "Contratos Menores"

          @observaciones << "**  CORRECCIÓN: Contratos Menores* - por - Contratos Menores - "

        when 'Facturación*'
          description = "Facturación"

          @observaciones << "**  CORRECCIÓN: Facturación* - por - Facturación - "

        when 'Inspecciones en materia de protección animal *'
          description = "Inspecciones en materia de protección animal"

          @observaciones << "**  CORRECCIÓN: Inspecciones en materia de protección animal * - por - Inspecciones en materia de protección animal * - "

        when 'Atención, orientación e información a los consumidores*'
          description = "Atención, orientación e información a los consumidores"

          @observaciones << "**  CORRECCIÓN: Atención, orientación e información a los consumidores* - por - Atención, orientación e información a los consumidores - "

        when 'Información servicios sanitarios, calidad y consumo*'
          description = "Información servicios sanitarios, calidad y consumo"

          @observaciones << "**  CORRECCIÓN: Información servicios sanitarios, calidad y consumo* - por - Información servicios sanitarios, calidad y consumo - "

        when 'Nº liquidaciones'
          description = "N º liquidaciones"
          @observaciones << "** CORRECCIÓN: - Nº liquidaciones - por - N º liquidaciones - "

        when 'Contratos derivados del acuerdo Marco  (*2)'
          description = "Contratos derivados del acuerdo Marco"
          @observaciones << "** CORRECCIÓN: - Contratos derivados del acuerdo Marco  (*2) - por - Contratos derivados del acuerdo Marco - "

        when 'nº autorizaciones informadas (*4)'
          description = "nº autorizaciones informadas"

          @observaciones << "** CORRECCIÓN: - nº autorizaciones informadas (*4) - por - nº autorizaciones informadas - "

        when 'nº concesiones informadas (*4)'
          description = "nº de concesiones informadas"

          @observaciones << "** CORRECCIÓN: - nº concesiones informadas (*4) - por - nº concesiones informadas - "

        when 'nº expedientes informados (*4)'
          description = "nº expedientes informados"

          @observaciones << "** CORRECCIÓN: - nº expedientes informados (*4) - por - nº expedientes informados - "

        when 'n.º expedientes  informados  (*4)'
          description = "nº expedientes informados"

          @observaciones << "** CORRECCIÓN: - n.º expedientes  informados  (*4) - por - nº expedientes  informados - "

        when 'metros cuadrados totales a mantener (*6)'
          description = "metros cuadrados totales a mantener"

          @observaciones << "** CORRECCIÓN: - metros cuadrados totales a mantener (*6) - por - metros cuadrados totales a mantener - "

        when 'nº de edificios (*7)'
          description = "nº de edificios"

          @observaciones << "** CORRECCIÓN: - nº de edificios (*7) - por - nº de edificios - "

        when 'nº de planes aprobados (*8)'
          description = "nº de planes aprobados"

          @observaciones << "** CORRECCIÓN: - nº de planes aprobados (*8) - por - nº de planes aprobados - "

        when 'Información urbanística (*5)'
          description = "Información urbanística"

          @observaciones << "** CORRECCIÓN: - Información urbanística (*5) - por - Información urbanística - "

        when 'EXPTES .DE DISCIPLINA URBANÍSTICA DEPARTAMENTO JURÍDICO'
          description = "EXPTES .DE DISCIPLINA DEPARTAMENTO JURÍDICO"

          @observaciones << "** CORRECCIÓN: - EXPTES .DE DISCIPLINA URBANÍSTICA DEPARTAMENTO JURÍDICO - por - EXPTES .DE DISCIPLINA DEPARTAMENTO JURÍDICO - "


        when 'EXPTES .DE DISCIPLINA  DEPARTAMENTO JURÍDICO'
          description = "EXPTES .DE DISCIPLINA DEPARTAMENTO JURÍDICO"

          @observaciones << "** CORRECCIÓN: - EXPTES .DE DISCIPLINA  DEPARTAMENTO JURÍDICO - por - EXPTES .DE DISCIPLINA DEPARTAMENTO JURÍDICO - "

        when 'EXPTES. DE DISCIPLINA  DEPARTAMENTO JURÍDICO'
          description = "EXPTES .DE DISCIPLINA DEPARTAMENTO JURÍDICO"

          @observaciones << "** CORRECCIÓN: - EXPTES. DE DISCIPLINA  DEPARTAMENTO JURÍDICO - por - EXPTES .DE DISCIPLINA DEPARTAMENTO JURÍDICO - "

        when 'Expedición de documentos de licencias (se incluye documento comunicación previa correcta que se envía al interesado)'
          description = "Expedición de documentos de licencias"

          @observaciones << "** CORRECCIÓN: - Expedición de documentos de licencias (se incluye documento comunicación previa correcta que se envía al interesado) - por - Expedición de documentos de licencias - "

        when 'Información servicios sanitarios, calidad y consumo*'
          description = "Información servicios sanitarios, calidad y consumo"

          @observaciones << "** CORRECCIÓN: - Información servicios sanitarios, calidad y consumo* - por - Información servicios sanitarios, calidad y consumo - "
        when 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONOMICOS'
          description = "OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS"

          @observaciones << "** CORRECCIÓN: - OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONOMICOS - por - OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS - "

        when 'nº autorizaciones resueltas'
          description = "n.º autorizaciones resueltas"

          @observaciones << "** CORRECCIÓN: - nº autorizaciones resueltas - por - n.º autorizaciones resueltas - "

        when 'nº autorizaciones solicitadas'
          description = "n.º autorizaciones solicitadas"

          @observaciones << "** CORRECCIÓN: - nº autorizaciones solicitadas - por - n.º autorizaciones solicitadas - "

        when 'SIGSA (LA FUENTE ES AS400)'
          description = "SIGSA"
          @observaciones << "** CORRECCIÓN: - SIGSA (LA FUENTE ES AS400) - por - SIGSA - "

        when 'SIGSA y EN WORD'
          description = "SIGSA"
          @observaciones << "** CORRECCIÓN: - SIGSA y EN WORD - por - SIGSA - "

        when 'Actas sesiones:46'
          description = "Actas sesiones"
          @observaciones << "** CORRECCIÓN: - Actas sesiones:46 - por - Actas sesiones - "

        when 'nº de sesiones:46'
          description = "nº de sesiones"
          @observaciones << "** CORRECCIÓN: - nº de sesiones:46 - por - nº de sesiones - "

        when 'Expedientes sancionadores no urbansiticos (inlcuye terraza y veladores)'
          description = "Expedientes sancionadores no urbanísticos (incluye terrazas y veladores)"
          @observaciones << "** CORRECCIÓN: - Expedientes sancionadores no urbansiticos (inlcuye terraza y veladores) - por - Expedientes sancionadores no urbanísticos (incluye terrazas y veladores) - "

        when 'Consejo Territorial (Consejos-sesiones)'
          description = "Consejo Territorial"
          @observaciones << "** CORRECCIÓN: - Consejo Territorial (Consejos-sesiones) - por - Consejo Territorial - "

        when 'PLACT- Tres trimestres'
          description = "PLACT"
          @observaciones << "** CORRECCIÓN: - PLACT- Tres trimestres - por - PLACT - "

        when 'Intereses devolución de ingresos, liquidaciones a devolver (3)'
          description = "Intereses devolución de ingresos, liquidaciones a devolver"
          @observaciones << "** CORRECCIÓN: - Intereses devolución de ingresos, liquidaciones a devolver (3) - por - Intereses devolución de ingresos, liquidaciones a devolver - "

        when 'Devolución ingresos indebidos (3)'
          description = "Devolución ingresos indebidos"
          @observaciones << "** CORRECCIÓN: - Devolución ingresos indebidos (3) - por - Devolución ingresos indebidos - "

        when 'Expedientes sancionadores no urbanisticos (incluye terrazas de veladores)'
          description = "Expedientes sancionadores no urbanísticos (incluye terrazas y veladores)"
          @observaciones << "** CORRECCIÓN: - Expedientes sancionadores no urbanisticos (incluye terrazas de veladores) - por - Expedientes sancionadores no urbanísticos (incluye terrazas y veladores) - "

        when 'Informes actos deportivos, culturales  en via publica'
          description = "Informes actos deportivos, culturales en via publica"
          @observaciones << "** CORRECCIÓN: - Informes actos deportivos, culturales  en via publica - por - Informes actos deportivos, culturales en via publica - "

        when 'Inspecciones de piscinas, peluquerías , piercing, tatuaje, centros recreo y cuidado  infantil,'
          description = "Inspecciones de piscinas, peluquerías , piercing, tatuaje, centros recreo y cuidado infantil, tiendas de animales"
          @observaciones << "** CORRECCIÓN: - Inspecciones de piscinas, peluquerías , piercing, tatuaje, centros recreo y cuidado  infantil, - por - Inspecciones de piscinas, peluquerías , piercing, tatuaje, centros recreo y cuidado infantil, tiendas de animales - "

        when 'ASISTENCIA A  ÓRGANOS COLEGIADOS (1)'
          description = "ASISTENCIA A ÓRGANOS COLEGIADOS"
          @observaciones << "** CORRECCIÓN: - ASISTENCIA A  ÓRGANOS COLEGIADOS (1) - por - ASISTENCIA A ÓRGANOS COLEGIADOS - "

        when 'Gestión de personal (2)'
          description = "Gestión de personal"
          @observaciones << "** CORRECCIÓN: - Gestión de personal (2) - por - Gestión de personal - "

        when 'nº de solicitudes tramitadas en la CM -'
          description = "nº de solicitudes tramitadas en la CM"
          @observaciones << "** CORRECCIÓN: - nº de solicitudes tramitadas en la CM - - por - nº de solicitudes tramitadas en la CM - "

        when 'Actuaciones para garantizar la atención social básica en servicios sociales UTS .'
          description = "Actuaciones para garantizar la atención social básica en servicios sociales UTS"
          @observaciones << "** CORRECCIÓN: - Actuaciones para garantizar la atención social básica en servicios sociales UTS . - por - Actuaciones para garantizar la atención social básica en servicios sociales UTS - "

        when 'nº de sesiones 60'
          description = "nº de sesiones"
          @observaciones << "** CORRECCIÓN: - nº de sesiones 60 - por - nº de sesiones - "

        when 'N expedientes tramitados'
          description = "Nº expedientes tramitados"
          @observaciones << "** CORRECCIÓN: - N expedientes tramitados - por - Nº expedientes tramitados - "

        end #case
      end
    else
      @observaciones << "ERROR: Descripción no es cadena: #{description}"
    end
    return description
  end

  def convert_om(description)
    if description.nil? then
      description = ""
    end

    description.strip! # Elimina blancos

    case  description
    when "DEPARTAMENTO DE SERVICIOS JURÍDICOS" then
      "DEPARTAMENTO DE SERVICIOS JURIDICOS"
    when "DEPARTAMENTO DE SERVICIOS TÉCNICOS" then
      "DEPARTAMENTO DE SERVICIOS TECNICOS"
    when "DEPARTAMENTO DE SERVICIOS ECONÓMICOS" then
      "DEPARTAMENTO DE SERVICIOS ECONOMICOS"
    when "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS" then
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
#       puts "  Efectivos: #{@staff}"
#       puts "  Indicadores: #{@num_indicators} total: #{@tot_indicators}"
    end
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
    when value.class.to_s == "Spreadsheet::Formula"
      value.value
    else
      value
    end
  end

  def cab_log
    @linea = 0
    @hash_log[:linea] = "LINEA;\n"
    @hash_log[:observaciones] = "OBSERVACIONES;\n"
    @hash_log[:organizacion] = "ORGANIZACIÓN;"
    @hash_log[:tipo_unidad] = "UNIDAD;"
    @hash_log[:proceso] = "PROCESO;"
    @hash_log[:sub_proceso] = "SUB_PROCESO;"
    @hash_log[:indicador] = "INDICADOR;"
    @hash_log[:metrica] = "METRICA;"
    @hash_log[:fuente] = "SOURCE;"
    @hash_log.each do |k, v|
      print "#{v}"
    end
  end

  def write_log(observaciones, type = "")
      @linea = @linea + 1
      @hash_log[:linea] = "#{@linea.to_s}"
      @hash_log[:observaciones] = "#{observaciones}"
      @hash_log[:organizacion] =  @o.nil? ? "organización" :  @o.description
      @hash_log[:tipo_unidad]  =  @ut.nil? ? "tipo_unidad" :  @ut.description
      if type == "main_process"
        @hash_log[:proceso] = type
       if observaciones["ERROR"]
          @hash_log[:sub_proceso] = "sub_process"
          @hash_log[:indicador] = "indicador"
          @hash_log[:metrica] =  "metrica"
          @hash_log[:fuente] =   "fuente"
          @mp = @sp = @ind = @mt = @sr = nil
        end
      else
        @hash_log[:proceso] =  @mp.nil? ? "proceso" :  @mp.item.description
      end
      if type == "sub_process"
        @hash_log[:sub_proceso] = type
        if observaciones["ERROR"]
          @hash_log[:indicador] = "indicador"
          @hash_log[:metrica] =  "metrica"
          @hash_log[:fuente] =   "fuente"
          @sp = @ind = @mt = @sr = nil
        end
      elsif @sp.nil?
        @hash_log[:sub_proceso] = "sub_proceso"
        @ind = @mt= @sr = nil
      else
        @hash_log[:sub_proceso] = @sp.item.description
      end
      if type == "indicator"
        @hash_log[:indicador] = type
        if observaciones["ERROR"]
          @hash_log[:metrica] =  "metrica"
          @hash_log[:fuente] =   "fuente"
          @ind = @mt = @sr = nil
        end

      elsif @ind.nil?
        @hash_log[:indicador] = "indicador"
      else
        @hash_log[:indicador]  = @ind.item.description
      end

      if type == "metric"
        @hash_log[:metrica] = type
        if observaciones["ERROR"]
          @hash_log[:fuente] =   "fuente"
          @mt = @sr = nil
        end
      elsif @mt.nil?
        @hash_log[:metrica] =  "metrica"
      else
        @hash_log[:metrica] = @mt.item.description
      end

      if type == "source"
        @hash_log[:fuente] = type
      elsif @sr.nil?
        @hash_log[:fuente] =   "fuente"
      else
        @hash_log[:fuente] =  @sr.item.description
      end


    if @hash_log[:observaciones].include?("ERROR")  || @hash_log[:observaciones].include?("CORRECCIÓN")
      @hash_log.each do |k, v|
 #       v.gsub(/[,;]/, " ") if v.class.to_s == "String"
 #       @hash_log[:observaciones] << "\n"
        print "#{v};"
      end
      print "\n"
     end

  end

  def init_log
    @hash_log = Hash.new(";")
  end

  def clear_data
    IndicatorMetric.delete_all
    IndicatorSource.delete_all
    Source.delete_all
    Metric.delete_all
    EntryIndicator.delete_all
    Indicator.delete_all
    Task.delete_all
    SubProcess.delete_all
    MainProcess.delete_all
    Item.delete_all
  end
