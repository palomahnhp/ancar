namespace :total_indicators do
  require 'spreadsheet'
=begin
  Tiene una única tarea, load, que carga los datos de la tabla
=end

  desc "Import adding up indicators"
  task load: :environment do
    fichero = "../Sumandos.xls"
    libro = Spreadsheet.open fichero

    cab_log
    write_log
    init_log
    #clear_data
    TotalIndicator.delete_all
    @per = Period.first
    @num_main_process = 0
    @num_sub_process = 0
    @num_indicators = 0
    @tot_indicators = 0
    #@cell_amount = 0
    @organization_type = OrganizationType.where(description: 'Distritos').first
#### TODO: bucle para 21 JD    
    @o = Organization.first # Probamos con una JD. ¿¿¿¿??????


    (3..10).each do |i|

      hoja = libro.worksheet i
      puts "Procesando hoja #{hoja.name}"
      @cell_unit_type =  hoja.row(3)[1]
      @hash_log[:tipo_unidad] = @cell_unit_type unless @process_structure
      get_unit


      ####### ADAPTANDO ##########################
      (hoja.rows).each do |f|

        next if  f.idx.between?(0,5)
        #cols = f.count

        case
        when f[0] == 0 then
          break

        when !f[0].nil? && (f[0].is_a? Numeric) && (f[0].between?(1,25)) then #MainProcess
          import_process('main_process', f[1])
          puts "Proceso: #{@mp.id} #{@mp.item.description}"
          
         when !f[2].nil? then # subprocess
          import_process('sub_process', f[3])
          #puts "Subproceso: #{@sp.id} #{@sp.item.description}"

         #  # En el caso de los distritos la tarea es única y no viene en el csv
           import_process('task', 'Tarea')
           #@tk = Task.where(sub_process_id: @sp.id, item_id: 3, updated_by: "import").first
           #puts "Tarea: #{@tk}"

        # when  f[3] == 'TOTAL  SUBPROCESO' then # efectivos subprocess

        when  !f[3].nil? && f[3] != 'TOTAL  SUBPROCESO' # indicator
=begin
          description = f[3]
          convert_string(description)
          # @metric = f[4]
          # @in_out = f[7]
          # @type = f[8]
          # @indicator_group = f[9]
          # if !@type.nil?
          #   #puts "Indicador: #{@indicator} Métrica: #{@metric} InOut: #{@in_out} Type: #{@type} IndicatorGroup: #{@indicator_group}"
          @indicator_it = Item.where(item_type: 'indicator', description: description)
          if @indicator_it.nil?
            puts "NULO"
          else
            puts "#{@indicator_it} #{description}"
          end
          ####### @ind = Indicator.where(task_id: @tk.id, item_id:id).first
          ####### puts "Indicador: #{@ind.id} #{@ind.item.description}"
          #   puts ""
          #   #puts "Indicador: #{@indicator_it.id} #{@indicator_it.description}"
          # end
=end

          @cell_metric = f[4]
          @hash_log[:metrica] = @cell_metric unless @process_structure
          @cell_source = f[5]
          #   if f[6].class.to_s == 'Spreadsheet::Formula'
          #     @cell_amount = f[6].value
          #   elsif f[6].class.to_s  == 'Fixnum' || f[6].class.to_s  == 'Float'
          #     @cell_amount =  f[6]
          #   else
          @cell_amount = 0
          #   end
          #@hash_log[:cantidad] = @cell_metric unless @process_structure
          @type = f[8]
          @indicator_group = f[9]
          if !@type.nil?
            import_process('indicator', f[3])
            if !@ind.nil?
              #puts "Indicador: #{@ind.id} #{@ind.item.description}"
              #puts "Metrica: #{@mt.id} #{@mt.item.description}"
              @ind_mt = IndicatorMetric.where(indicator_id: @ind.id, metric_id: @mt.id).first
              if !@ind_mt.nil?
              @ind_gr_id = nil
#=begin
                if !@indicator_group.nil? #### VER XQ NO RECUEPRA IND-GR
                  #convert_string(@indicator_group) # almacena el valor en description
                  @ind_gr = IndicatorGroup.where(description: @indicator_group).first
                  if !@ind_gr.nil?
                    #puts "IndicatorGroup: #{@ind_gr.id} #{@ind_gr.description}"
                    @ind_gr_id = @ind_gr.id
                  else
                    puts "\N======> INDICATOR GROUP NO ENCONTRADO"
                  end
                end
#=end
                puts "IndicatorMetricId = #{@ind_mt.id}, Type = #{@type}, IndicatorGroup = #{@ind_gr_id}"
                
                for i in (0..@type.length-1);
                  TotalIndicator.create!(indicator_metric_id: @ind_mt.id, type: @type[i], indicator_group_id: @ind_gr_id, updated_by: 'import')
                end

              else
                puts "INDICATOR-METRIC NO EXISTE"
              end
            else
              puts "\n=====> NO EXISTE EL INDICADOR: #{f[3]}"
            end
          end
        end
      end




      ####### FIN DE ADAPTANDO ###################
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
    reset_vars
    if (hoja.name.include? "Hoja")
      return
    end
    if (hoja.name.downcase.include? "ncidencia")
      return
    end
    @hash_log[:distrito] = "\n#{hoja.name}"
    # Procesando cabecera de la hoja
    if @first_time
      @organization_type = "Distritos"
      @cell_period = hoja.row(2)[1]
      get_period_organization
    end

    @cell_unit_type =  hoja.row(3)[1]
    @hash_log[:tipo_unidad] = @cell_unit_type unless @process_structure

    get_unit

    if !@process_structure
      @cell_efectivos_unit = { A1: process_cell(hoja.row(7)[7]),
                               A2: process_cell(hoja.row(7)[8]),
                               C1: process_cell(hoja.row(7)[9]),
                               C2: process_cell(hoja.row(7)[10]),
                               E:  process_cell(hoja.row(7)[11])}
      treat_proc("staff_unit", 0, "")

      @hash_log[:u_A1] = @cell_efectivos_unit[:A1] unless @process_structure
      @hash_log[:u_A2] = @cell_efectivos_unit[:A2] unless @process_structure
      @hash_log[:u_C1] = @cell_efectivos_unit[:C1] unless @process_structure
      @hash_log[:u_C2] = @cell_efectivos_unit[:C2] unless @process_structure
      @hash_log[:u_E] = @cell_efectivos_unit[:E] unless @process_structure

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

          @hash_log[:sp_A1] = @cell_efectivos_sub_proc[:A1] unless @process_structure
          @hash_log[:sp_A2] = @cell_efectivos_sub_proc[:A2] unless @process_structure
          @hash_log[:sp_C1] = @cell_efectivos_sub_proc[:C1] unless @process_structure
          @hash_log[:sp_C2] = @cell_efectivos_sub_proc[:C2] unless @process_structure
          @hash_log[:sp_E] = @cell_efectivos_sub_proc[:E] unless @process_structure

          treat_proc("staff", 0, "")
        end
      when  !f[3].nil? && f[3] != 'TOTAL  SUBPROCESO' # indicator
        @cell_metric = f[4]
        @hash_log[:metrica] = @cell_metric unless @process_structure
        @cell_source = f[5]
        if f[6].class.to_s == 'Spreadsheet::Formula'
          @cell_amount = f[6].value
        elsif f[6].class.to_s  == 'Fixnum' || f[6].class.to_s  == 'Float'
          @cell_amount =  f[6]
        else
          @cell_amount = 0
        end
        @hash_log[:cantidad] = @cell_metric unless @process_structure
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
 #      puts "UNIT_TYPE:          #{@ut.description}"
    else
      @hash_log[:observaciones] = "*** ERROR: Tipo de unidad no encontrada: #{@cell_unit_type} #{@sap_id}\n"

      write_log
      raise "Error: Tipo de unidad no encontrada: #{@cell_unit_type} #{@sap_id}"
    end
    @u = Unit.where(unit_type_id: @ut.id, organization_id: @o.id).first
    if @u
#      # puts "UNIT: #{@u.description_sap}"
    else

      @hash_log[:observaciones] = "*** ERROR: Unidad no encontrada: #{@cell_unit_type} #{@sap_id}\n"
      write_log
      raise "Error: Unidad no encontrada: #{@cell_unit_type} #{@sap_id}"
    end
    @hash_log[:unidad] = @u.description_sap unless @process_structure
    @cell_unit_type  = @cell_unit = nil
  end

  def import_process(type, description)
    if description.nil? then description = "" end
    convert_string(description)
    if description == ""
      @hash_log[:observaciones] = "*** ERROR - Description a blancos id #{type}"
    end

    item = Item.where(item_type: type, description: description)
    if item.empty? # NO existe item
      if @process_structure # se crea item solo oen proceso de estructura
        it = Item.create!(item_type: type, description: description, updated_by: "import")
      else
        @hash_log[:observaciones] = "*** ERROR: #{type} #{description} no existe"
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
      stats("ma@tot_indicatorsin_process")
      @mp = MainProcess.where(period_id: @per.id, item_id: id, updated_by: "import").first
      if @mp.nil?
        if @process_structure # se crea item solo en proceso de estructura
          o_max = MainProcess.maximum(:order)
          o_max = o_max.nil?  ? 1 : (o_max + 1)
          @mp = MainProcess.create!(period_id: @per.id, item_id: id,
                                  order:o_max, updated_by: "import")
        else
          @hash_log[:observaciones] = "*** ERROR: MainProcess no existe "
        end
      end
      @hash_log[:proceso] = @mp.item.description
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
          @hash_log[:observaciones] = "*** ERROR: SubProcess no existe: #{@¢ell_sub_process}. "
        end
      else
        @hash_log[:sub_proceso] = @sp.item.description
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
        @hash_log[:tarea] = @tk.item.description
      end

    when "indicator" # Por defecto se cargan de salida, y si es necesario se modifican por la app
        @ind = Indicator.where(task_id: @tk.id, item_id:id).first
      if @ind.nil?
        if @process_structure # se crea item solo en proceso de estructura
          o_max = Indicator.maximum(:order)
          o_max = o_max.nil?  ? 1 : (o_max + 1)
          @ind = Indicator.create!(task_id: @tk.id, item_id:id, order: o_max, updated_by: "import")
        else
          @hash_log[:observaciones] = "*** ERROR: Indicator no existe #{@tk.item.description} "
        end
      end

      if @ind
        @hash_log[:indicador] = @ind.item.description
      end

      import_process('metric', @cell_metric)
      if @ind && @mt
        @im = IndicatorMetric.where(indicator_id: @ind.id, metric_id: @mt.id).first
      end
      if @im.nil?
        if @process_structure # se crea item solo en proceso de estructura
          @im = IndicatorMetric.create!(indicator_id: @ind.id, metric_id: @mt.id)
        else
          @hash_log[:observaciones] = "*** ERROR: IndicatorMetric no existe @ind.item.description @mt.item.description"
        end
      end

      if !@im.nil?
        @hash_log[:indicador_metrica] = "#{@im.indicator_id}/#{@im.metric_id} "
      end
      import_process('source', @cell_source)
      @hash_log[:cantidad] = @cell_amount unless @process_structure

      if @ind && @sr
        @is = IndicatorSource.where(indicator_id: @ind.id, source_id: @sr.id).first
        if @is.nil?
          if @process_structure # se crea item solo en proceso de estructura
            @is = IndicatorSource.create!(indicator_id: @ind.id, source_id: @sr.id)
          else
            @hash_log[:observaciones] = "*** ERROR: IndicatorSource no existe #{@ind.id}/#{@sr.id}"
          end
        else
         @hash_log[:indicador_fuente] = "#{@is.indicator_id}/#{@is.source_id} "
        end
      end
      if @is && @u && @im
        @ei = EntryIndicator.create!(unit_id: @u.id, indicator_metric_id: @im.id, specifications: nil, amount: @cell_amount, updated_by: "import")
      end
      @cell_metric = @cell_source = nil
      @num_indicators += 1
      @tot_indicators =  @tot_indicators + @cell_amount
      write_log
      indicator_init_log

    when "metric"
      @mt = Metric.where(item_id: id).first
      if @mt.nil?
        if @process_structure # se crea item solo en proceso de estructura
          in_out = in_out(@ut.description, @ind.item.description, Item.find(id).description)
          @mt = Metric.create!(item_id: id, in_out: in_out, updated_by: "import")
        else
          @hash_log[:observaciones] = "*** ERROR: Metric no existe "
        end
      end
      @hash_log[:metrica] = "#{@mt.item.description}"
    when "source"
      @sr = Source.where(item_id: id, fixed: true, has_specification: false, updated_by: "import").first
      if @sr.nil?
        if @process_structure # se crea item solo en proceso de estructura
          @sr = Source.create!(item_id: id, fixed: true, has_specification: false, updated_by: "import")
        else
          puts "*** ERROR: Source no existe "
        end
        @hash_log[:source] = "#{@sr.item.description}"
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
  end

  def convert_string(description)
    if description.nil? then
      description = ""
    end
    if description.is_a?(String)
      description.strip! # Elimina blancos
      description["\n"] = ""  if description["\n"] # Elimina \n
      description["  "] = " " if description["  "] # dos espacios
      description[";"] = ","  if description[";"]  # Elimina ;
     else
      @hash_log[:observaciones] = "ERROR: Descripción no es cadena: #{description}"
    end
  end

  def convert_om(unit_type_description)
    # Se igual el nombre de las hojas con indicadores con el de EOM
    if unit_type_description.nil? then
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
#       puts "  Efectivos: #{@staff}"
#       puts "  Indicadores: #{@num_indicators} total: #{@tot_indicators}"
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
    when value.class.to_s == "Spreadsheet::Formula"
      value.value
    else
      value
    end
  end

  def cab_log
    @hash_log = Hash.new(";")
    @hash_log[:distrito] = "DISTRITO"
    @hash_log[:tipo_unidad] = "UNIDAD"
    @hash_log[:unidad] = "UNIDAD"
    @hash_log[:u_A1] = "UNIDAD_A1"
    @hash_log[:u_A2] = "UNIDAD_A2"
    @hash_log[:u_C1] = "UNIDAD_C1"
    @hash_log[:u_C2] = "UNIDAD_C2"
    @hash_log[:u_E]  = "UNIDAD_E"
    @hash_log[:proceso] = "PROCESO"
    @hash_log[:sub_proceso] = "SUB_PROCESO"
    @hash_log[:sp_A1] = "UNIDAD_A1"
    @hash_log[:sp_A2] = "UNIDAD_A2"
    @hash_log[:sp_C1] = "UNIDAD_C1"
    @hash_log[:sp_C2] = "UNIDAD_C2"
    @hash_log[:sp_E]  = "UNIDAD_E"
    @hash_log[:indicador] = "INDICADOR"
    @hash_log[:cantidad] = "CANTIDAD"
    @hash_log[:fuente] = "SOURCE"
    @hash_log[:e_s] = "E_S"
    @hash_log[:metrica] = "METRICA"
    @hash_log[:observaciones] = "OBSERVACIONES"
  end

  def write_log
    if @hash_log[:observaciones].include?("ERROR")
      @hash_log.each do |k, v|
        v.gsub(/[,;]/, " ") if v.class.to_s == "String"
        print "#{v};"
      end
    end
  end

  def init_log
    @hash_log = Hash.new(";")
  end

  def indicator_init_log
    @hash_log[:indicador] = ";"
    @hash_log[:fuente] = ";"
    @hash_log[:e_s] = ";"
    @hash_log[:metrica] = ";"
    @hash_log[:cantidad] = ";"
    @hash_log[:observaciones] = ";"
  end

  def clear_data
    puts "\n *** Limpiando procesos *** "
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
