namespace :data_control do

  desc "Validación de indicadores: "
  task indicators: :environment do
    puts '- indicadores invalidos'
    puts '- ---------------------'
    invalid_assignaments = Indicator.select(&:invalid?)
    invalid_assignaments.each do |i|
      i.valid?
      puts "Indicador: #{i.id} -#{i.item.description} #{i.task.sub_process.unit_type_id}-> "
      puts "   #{i.errors.messages}"
    end

    puts "Indicadores Totales: #{Indicator.all.count}"
    puts "Indicadores con errores: #{invalid_assignaments.count}"
  end

  desc "Validar entry_indicadores"
  task entry_indicators: :environment do
    puts '- entry_indicators invalids'
    puts '- -------------------------'
    invalid_assignaments = EntryIndicator.select(&:invalid?)
    invalid_assignaments.each do |ei|
      ei.valid?
      puts "EntryIndicator: #{ei.id}  Unit: #{ei.unit_id} im: #{ei.indicator_metric_id} is: #{ei.indicator_source_id}-> "
      puts "   #{ei.errors.messages}"
    end

    puts "EntryIndicators Totales: #{EntryIndicator.all.count}"
    puts "EntryIndicators con errores: #{invalid_assignaments.count}"

  end
end
