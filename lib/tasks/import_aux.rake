private
  def process_units(hoja, i, organization_type)
    @organization_type = OrganizationType.where(acronym: organization_type).first
    (hoja.rows).each  do |f|

      next if f[1].nil? || f[1] == "DIRECCIÓN" || f[1] == "COD. UNIDAD" # no procesa fila 1, cabecera
      @id_sap = f[1]
      @nombre = f[2]
      @JM_id_sap = f[8]
      @JM_nombre = f[9]
      create_unit(@organization_type.description, i)
    end
  end

  def create_unit(name, i )
    if @JM_id_sap # departamentos
      ut = UnitType.where(description: name).first
 #     puts "  Creado Dpto #{@nombre} "
      @num += 1
      if ut.nil?
        ut = UnitType.create(description: name, order: 1, updated_by: "import")
 #       raise "Error buscando tipo unidad #{@sap_id} #{name}"
      end
      o = Organization.where(sap_id: @JM_id_sap).first
      if o.nil?
        o = Organization.create!(organization_type_id: @organization_type.id, description: @nombre, sap_id: @id_sap)
      end
      u = Unit.create!(unit_type_id: ut.id, organization_id: o.id, description_sap: @nombre, sap_id: @id_sap, order: ut.order)
    else # JM
      o = Organization.create!(organization_type_id: @organization_type.id, description: @nombre, sap_id: @id_sap)
#      puts "  Creada JM #{@nombre}"
      @num += 1
      @JM_id_sap = @JM_nombre = nil
    end
  end

  def process_sheet(hoja, file_name)
    @observaciones = ""
    puts ".... #{hoja.name}"
    reset_vars
    if hoja.name.include? "Hoja"
      return
    end
    if hoja.name.downcase.include? "ncidencia"
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
        @order = f[0]
        if @order == 0 then @order = 90 end
        import_process('main_process', f[1])
       when !f[2].nil? then # subprocess
        @order = f[2].to_s
        if @order[0] == '0' then @order[0]  = '9'  end
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
#       puts @o.description
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
    if description == "" && !(type == "metric" || type == "source")
      write_log("*** AVISO: Se carga #{type} con description a blancos}")
    end

    item = Item.where(item_type: type, description: description)
    if item.empty? # NO existe item
      # se crea item solo oen proceso de estructura
      if @fuerce || @process_structure || ( !@mp.nil? && @mp.item.description == 'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)')
        it = Item.create!(item_type: type, description: description, updated_by: "import")
      else
         write_log("*** ERROR fuerce: #{@fuerce}: item no existe: #{type} #{description} no existe")
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
      @mp = MainProcess.where(period_id: @per.id, item_id: id, updated_by: "import").first
      if @mp.nil?
        if @process_structure # se crea item solo en proceso de estructura
          @mp = MainProcess.create!(period_id: @per.id, item_id: id,
                                  order: @order, updated_by: "import")
        else
          write_log("*** ERROR: MainProcess no existe ", "main_process")
        end
      end
      @num_main_process += 1

    when "sub_process"

      @sp = SubProcess.where(unit_type_id: @ut.id, main_process_id: @mp.id,
                             item_id: id, updated_by: "import").first
      if @sp.nil?
        if @fuerce || @process_structure || (!@mp.nil? && @mp.item.description == 'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)')
          @sp = SubProcess.create!(unit_type_id: @ut.id,
                      main_process_id: @mp.id, item_id: id, order:@order, updated_by: "import")
        else
          write_log("*** ERROR fuerce: #{@fuerce}: SubProcess no existe: proceso: #{@mp.item.description} sub_process item_id #{id}" )
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
        if @fuerce || @process_structure || type =='indicator' && !@mp.nil? && @mp.item.description == 'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)'
          o_max = Indicator.maximum(:order)
          o_max = o_max.nil?  ? 1 : (o_max + 1)
          @ind = Indicator.create!(task_id: @tk.id, item_id:id, order: o_max, updated_by: "import")
        else
          write_log("*** ERROR fuerce: #{@fuerce}: Indicator no existe #{Item.find(id).description}")
        end
      end

      import_process('metric', @cell_metric)
      if @ind && @mt
        @im = IndicatorMetric.where(indicator_id: @ind.id, metric_id: @mt.id).first
      end
      if @im.nil?
        if @fuerce || @process_structure || (!@mp.nil? && @mp.item.description == 'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)')
          @im = IndicatorMetric.create!(indicator_id: @ind.id, metric_id: @mt.id)
        else
          write_log("*** ERROR: IndicatorMetric no existe #{@ind.item.description} #{@mt.item.description}")
        end
      end

      import_process('source', @cell_source)
 #     @hash_log[:cantidad] = @cell_amount unless @process_structure
      if @ind && @sr
        @is = IndicatorSource.where(indicator_id: @ind.id, source_id: @sr.id).first
        if @is.nil?
          if @fuerce || @process_structure || (!@mp.nil? && @mp.item.description == 'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)')
            @is = IndicatorSource.create!(indicator_id: @ind.id, source_id: @sr.id)
          end
        end
      end
      if @is && @u && @im
        if !@process_structure
          @ei = EntryIndicator.create!(unit_id: @u.id, indicator_metric_id: @im.id, specifications: nil, amount: @cell_amount, updated_by: "import")
        end
      else
        puts "ERROR: no se crea entry indicator #{@ind.item.description} #{@cell_amount}"
      end
      @cell_metric = @cell_source = nil
      @num_indicators += 1
      @tot_indicators =  @tot_indicators + @cell_amount

    when "metric"
      @mt = Metric.where(item_id: id).first
      if @mt.nil?
        if @fuerce || @process_structure || (!@mp.nil? && @mp.item.description == 'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)')
          @mt = Metric.create!(item_id: id, in_out: "in", updated_by: "import")
        else
          write_log("*** ERROR: Metric NO existe  #{Item.find(id).description}")
        end
      end
    when "source"
      @sr = Source.where(item_id: id, fixed: true, has_specification: false, updated_by: "import").first
      if @sr.nil?
       if @fuerce || @process_structure || (!@mp.nil? && @mp.item.description == 'OTROS PROCESOS (cumplimentar dedicación solo en el caso excepcional de que hubiera actividad del personal en otros procesos no identificados)')
          @sr = Source.create!(item_id: id, fixed: true, has_specification: false, updated_by: "import")
         else
        write_log("*** ERROR: Source NO existe #{Item.find(id).description}")
        end
      end

    when "staff"
      @cell_efectivos_sub_proc.each do |group, quantity|
        gr = OfficialGroup.where(name: group).first
        if @sp
          @ae = AssignedEmployee.create!(staff_of_id: @sp.id, staff_of_type: "SubProcess", official_group_id: gr.id,
            quantity: quantity, unit_id: @u.id, updated_by: "import")
           # print "      Staff : #{group} #{quantity} "
        end
      end

      @cell_efectivos_sub_proc = false
    when "staff_unit"
      if !@process_structure
        @cell_efectivos_unit.each do |group, quantity|
          gr = OfficialGroup.where(name: group).first
          @ae = AssignedEmployee.create!(staff_of_id: @u.id, staff_of_type: "Unit", official_group_id: gr.id,
            quantity: quantity, unit_id: @u.id, updated_by: "import")
           # print "      Staff : #{group} #{quantity} "
        end
      end
      @cell_efectivos_sub_proc = false
    end #end case
     write_log(@observaciones) unless @observaciones == ""
      @observaciones = ""
  end

  def convert_string(type, description)

   description.strip! if description.is_a?(String) # Elimina blancos
   description = "" if description.nil?

    if description.is_a?(String)

      if description["\n"]
        @observaciones << "** CORRECCIÓN: Eliminado retorno carro #{description}"
        description.gsub!(/\n/, "")
      end
      if description[" ,"]
        @observaciones << "** CORRECCIÓN: Eliminado blanco antes de coma #{description}"
        description.gsub!(/ ,/, ",")
      end

      if description["  "] # dos espacios
        description.gsub!(/  /, " ")
        @observaciones << "** CORRECCIÓN: Eliminado doble blanco #{description}"
      end

      if description[";"]
        @observaciones << "** CORRECCIÓN: Sustituido punto y como por , #{description}"
        description.gsub(/;/, ",")
      end

      if @correcciones[description] != ""
        desc = description
        @observaciones << "** CORRECCIÓN: #{desc} - por - #{description}"
        description = @correcciones[description]
      end

      if !@process_structure

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

  def write_log(observaciones = "", type = "")
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


    if @hash_log[:observaciones].include?("ERROR") # || @hash_log[:observaciones].include?("CORRECCIÓN")
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

  def cargar_cambios
    puts "Cargando correcciones..."
    file = "../correciones_textos_2015.xls"
    libro = Spreadsheet.open file
    @hoja = libro.worksheet 0
    @correcciones = Hash.new("")
    @hoja.rows.each do |fila|
      if fila[1].is_a?(String)
          clave = fila[1].strip.gsub(/  /, " ")
          valor = fila[2].strip.gsub(/  /, " ")
          @correcciones[clave] = valor
      end
    end
  end
