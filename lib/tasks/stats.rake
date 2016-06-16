namespace :stats do

  desc "Generate summary indicators for graphics"
  task agregar_indicadores: :environment do
    # Procesando cada distrito
     (10000002..10000002).each  do |id|
         process_district(id)
       end
    puts "Finalizada agregación de indicadores"
  end
end


private

  def  process_district(id)
   puts "\n**************** Procesando distrito #{id} *******************"
   units = Organization.find_by_sap_id(id).units

   units.each do |unit|
     ut = unit.unit_type
     puts "   ** Unidad: #{unit.description_sap} Tipo: #{ut.description} **"
      # Recorro todos los sub_procesos y busco sus Total indicators partiendo de su ind_met
      # compruebo si ya existe el registro - existe lo creo, no existe acumulo

     ut.sub_processes.each do |sp|
       process_indicators(unit, sp)
     end
   end
  end

  def process_indicators(unit, sp)

    puts "     -- Subproceso: #{sp.item.description} "
    ind_ids = sp.indicators.ids
    im_ids = IndicatorMetric.where(indicator_id:  ind_ids).ids
    total_indicators = TotalIndicator.where(indicator_metric_id: im_ids)
    total_indicators.each do |ti|
      entry_ind = ti.indicator_metric.entry_indicator
      # Buscar información de los indicadores y componer el registro a cargar en summary
      summary_process = SummaryProcess.where(unit_id: unit.id, process_type: sp.class.to_s,  process_id: sp.id).first
      if summary_process # se actualiza el amount
        summary_process.amount += entry_ind.amount
        summary_process.save
      else # se crea el registgro con el amount
=begin
  FALTA CALCULAR LOS EFECTIVOS:
=end
        summary_process = SummaryProcess.create(unit_id: unit.id, process_type: sp.class.to_s,  process_id: sp.id,
                                  amount: entry_ind.amount, A1: 0, A2: 0, C1: 0, C2: 0, E: 0, updated_by: 'stats')
      end
      puts "        + Total indicator: #{ind.item.description} cantidad: #{entry_ind.amount}"

    end
  end