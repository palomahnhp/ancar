namespace :import do
  require 'csv'
  # Hay que generar un csv por cada unidad a importar
  # se añaden dos columnas a la izda:
  # => period con id de periodo
  # => unit_type con id del tipo de unidad a cargar
  #

  desc "Import master data for unit_type (e.g. department)"
  task master_data: :environment do
    csv_text = File.read("unit_type.csv")
    csv=CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      import_data(row)
    end
#    load(Rails.root.join("db", "master_data.rb"))
  end

  desc "Import organizations data"
  task organizations: :environment do
    load(Rails.root.join("db", "organizations_data.rb"))
  end
end

private
  def import_data(row)
    parse_row(row)
    case
    when @cell_main_process then
      import_process('main_process', @cell_main_process)
    when @cell_sub_process then
      import_process('sub_process', @cell_sub_process)
# En el caso de los distritos la tarea es única y no viene en el csv
      import_process('task', 'Tarea')
    when @cell_indicator then
      import_process('indicator', @cell_indicator)
    end
  end

  def parse_row(row)
    if row["periodo"]
      @cell_period = row["periodo"]
    end
    if row["unidad"]
      @cell_unit_type = row["unidad"]
    end
    if row["tarea"]
      @cell_task = row["tarea"]
    end
    @cell_main_process = nil
    if row["num"] && row["proceso"]
      @cell_main_process = row["proceso"]
    end
    @cell_sub_process = nil
    if row["subproceso"]
      @cell_sub_process = row["indicador"]   # Está en la misma col que indicadores
    end
    @cell_indicator = @cell_metric = @cell_source = nil
    if row["indicador"]
      if row["indicador"] != 'TOTAL  SUBPROCESO'
        @cell_indicator = row["indicador"]
        @cell_metric = row["metrica"]
        @cell_source = row["fuente"]
      end
    end
  end

  def import_process(type, description)
    puts "Creando #{type} - #{description}"
    item = Item.where(item_type: type, description: description)
    if !item.empty? # existe item
      it = item.first
    else # se crea item
      it = Item.create!(item_type: type, description: description, updated_by: "import")
    end
    treat_proc(type, it.id)
  end

  def treat_proc(type, id)
    case type
    when "main_process"
      @mp = MainProcess.where(period_id: @cell_period, item_id: id, updated_by: "import").first
      if @mp.nil?
        o_max = MainProcess.maximum(:order)
        o_max = o_max.nil?  ? 1 : (o_max + 1)
        @mp = MainProcess.create!(period_id: @cell_period, item_id: id,
                                order:o_max, updated_by: "import")
      end
    when "sub_process"
      o_max = SubProcess.maximum(:order)
      o_max = o_max.nil?  ? 1 : (o_max + 1)
      @sp = SubProcess.where(unit_type_id: @cell_unit_type, main_process_id: @mp.id,
                             item_id: id, updated_by: "import").first
      if @sp.nil?
        @sp = SubProcess.create!(unit_type_id: @cell_unit_type,
                    main_process_id: @mp.id, item_id: id,  order:o_max, updated_by: "import")
      end
    when "task"
      @tk = Task.where(sub_process_id: @sp.id, item_id: id, updated_by: "import").first
      if @tk.nil?
        o_max = Task.maximum(:order)
        o_max = o_max.nil?  ? 1 : (o_max + 1)
        @tk = Task.create!(sub_process_id: @sp.id, item_id: id,  order:o_max, updated_by: "import")
      end

    when "indicator" # Por defecto se cargan de salida, y si es necesario se modifican por la app
      @ind = Indicator.where(task_id: @tk.id, item_id:id, in_out: "in").first
      if @ind.nil?
        o_max = Indicator.maximum(:order)
        o_max = o_max.nil?  ? 1 : (o_max + 1)
        import_process('metric', @cell_metric)
        @ind = Indicator.create!(task_id: @tk.id, item_id:id, in_out: "in",
                                  order: o_max, metric_id: @mt.id,
                                  total_process: 0, total_sub_process: 0)
        import_process('source', @cell_source)
        is = IndicatorSource.where(indicator_id: @ind.id, source_id: @sr.id)
      end

    when "metric"
      @mt = Metric.where(item_id: id).first
      if @mt.nil?
        @mt = Metric.create!(item_id: id, updated_by: "import")
      end

    when "source"
      @sr = Source.where(item_id: id, fixed: true, has_specification: false, updated_by: "import").first
      if @sr.nil?
        @sr = Source.create!(item_id: id, fixed: true, has_specification: false, updated_by: "import")
      end
    end #end case
  end
