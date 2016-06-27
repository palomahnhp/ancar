namespace :total_indicators do
  require 'spreadsheet'

  desc "Import adding up indicators"
  task load: :environment do
    fichero = "../SumandosRevisado.xls"
    libro = Spreadsheet.open fichero
    cargar_cambios
    init_log
    cab_log
    write_log
    TotalIndicator.delete_all
    @per = Period.first
    @num_main_process = 0
    @num_sub_process = 0
    @num_indicators = 0
    @tot_indicators = 0
    @organization_type = OrganizationType.where(description: 'Distritos').first
    @o = Organization.first # Probamos con una JD. ¿¿¿¿??????

    (3..10).each do |i|
      hoja = libro.worksheet i
      puts "Procesando hoja #{hoja.name}"
      @cell_unit_type =  hoja.row(3)[1]
      @hash_log[:tipo_unidad] = @cell_unit_type unless @process_structure
      get_unit
      (hoja.rows).each do |f|
        next if  f.idx.between?(0,5)
        case
        when f[0] == 0 then
          break
        when !f[0].nil? && (f[0].is_a? Numeric) && (f[0].between?(1,25)) then #MainProcess
          import_process('main_process', f[1])
          puts "Proceso: #{@mp.id} #{@mp.item.description}"
         when !f[2].nil? then # subprocess
          import_process('sub_process', f[3])
          import_process('task', 'Tarea')
        when  !f[3].nil? && f[3] != 'TOTAL  SUBPROCESO' # indicator
          @cell_metric = f[4]
          @hash_log[:metrica] = @cell_metric unless @process_structure
          @cell_source = f[5]
          @cell_amount = 0
          @type = f[8]
          @indicator_group = f[9]
          if !@type.nil?
            import_process('indicator', f[3])
            if !@ind.nil?
              @ind_mt = IndicatorMetric.where(indicator_id: @ind.id, metric_id: @mt.id).first
              if !@ind_mt.nil?
              @ind_gr_id = nil
                if !@indicator_group.nil?
                  @ind_gr = IndicatorGroup.where(description: @indicator_group).first
                  if !@ind_gr.nil?
                    @ind_gr_id = @ind_gr.id
                  else
#                    puts "\n======> INDICATOR GROUP NO ENCONTRADO"
                  end
                end
                puts "IndicatorMetricId = #{@ind_mt.id}, Type = #{@type}, IndicatorGroup = #{@ind_gr_id}"
                for i in (0..@type.length-1);
                  TotalIndicator.create!(indicator_metric_id: @ind_mt.id, indicator_type: @type[i], indicator_group_id: @ind_gr_id, updated_by: 'import')
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
    end
  end
end

