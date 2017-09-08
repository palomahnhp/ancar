namespace :indicator_metrics do
  require 'spreadsheet'

  desc "Initialize in_out_type  "
  task initialize_in_out_type: :environment do
    p 'Parameters: save: ' + ENV['save'] + ' entorno: ' + ENV['RAILS_ENV'] unless ENV['RAILS_ENV'].nil?
    p 'Initializing indicators in_out_type, updating ' + TotalIndicator.where(summary_type_id: [17, 18]).count.to_s + '... '
    count = 0
    TotalIndicator.where(summary_type_id: [17, 18]).each do |ti|
      im = IndicatorMetric.find_by(id: ti.indicator_metric_id)
      unless im.nil?
        im.in_out_type = ti.summary_type_id == 17 ? ti.in_out : 'X'
        im.save
        count += 1
      end
    end
    p count.to_s + ' regs updated'
  end

  desc "Initialize validation group  "
  task initialize_group: :environment do
    p 'Initializing validation group, regs ' + TotalIndicator.where(summary_type_id: 19).count.to_s + '... '
    count = 0
    TotalIndicator.where(summary_type_id: 19).each do |ti|
      im = IndicatorMetric.find_by(id: ti.indicator_metric_id)
      unless im.nil?
        im.validation_group_id = ti.indicator_group_id
        im.save
        count += 1
      end
    end
    p '... ' + count.to_s + ' regs updated'
  end


  desc 'import data_source and procedure from excel for Distritos '
  task import_JD_data_source: :environment do
    count_read = count_no_indicator = count_error_indicator = count_error_indicator_metric = count_updated =  0
    if ENV['period'].nil? || ENV['filename'].nil? || ENV['save'].nil?
      p '**'
      p '** ERROR: debe indicar id del periodo y file: rake entry_indicators:import period=10 filename=../nombrefichero.xls'
      p '**'
      exit
    end
    period = Period.find(ENV['period'].to_i)

    p 'Importing entry_indicators: ' + ENV['RAILS_ENV'].to_s + ' actualizaciOn: '+ ENV['save'] + ' ' + period.description + ', fichero: ' +ENV['filename']
    book  = Spreadsheet.open ENV['filename']
    unit_types = Hash.new
    unit_types['JURÍDICO'] = 'DEPARTAMENTO DE SERVICIOS JURIDICOS'
    unit_types['TÉCNICO '] = 'DEPARTAMENTO DE SERVICIOS TECNICOS'
    unit_types['ECONÓMICO'] = 'DEPARTAMENTO DE SERVICIOS ECONOMICOS'
    unit_types['CULTURAL, FORMAT. Y DEPORT.'] = 'UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS'
    unit_types['EDUCACIÓN '] = 'SECCION DE EDUCACION'
    unit_types['SOCIALES'] = 'DEPARTAMENTO DE SERVICIOS SOCIALES'
    unit_types['SANIT,CALIDAD Y CONSUMO '] = 'DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO'
    unit_types['SECRETARIA'] = 'SECRETARIA DE DISTRITO'

    (0..7).each do |n|
      sheet = book.worksheet n
      unit_type = UnitType.find_by_description(unit_types[sheet.name])
      p 'Tratando unidad: ' + unit_type.description
      (sheet.rows).each do |row|
        row[0] = 0 if row[0].nil?
        next unless row[0].is_a? Numeric
        count_read += 1
        if row[0] == 0
          p '  ** ERROR *** Indicador a blanco: ' + row[0].to_s + row[1].to_s + row[2].to_s
          count_no_indicator += 1
          next
        end
        indicators = Indicator.where(code: row[0].to_i)
        indicador = nil
        indicators.each do |ind|
          indicador = ind if ind.period == period
        end

        in_out = row[1]

        if indicador.nil?
          p '  ** ERROR *** No encontrado indicator code in_out: ' + row[0].to_i.to_s + '/'+ in_out.to_s
          count_error_indicator += 1
          next
        end

        im = IndicatorMetric.where(indicator_id: indicador.id, in_out_type: in_out).take
        if im.nil?
          p '  ** ERROR *** No encontrado indicator metric para indicator in_out: ' + indicador.code.to_s + '/' + indicador.id.to_s + '/' + in_out.to_s
          count_error_indicator_metric += 1
          next
        end
        im.data_source = row[9] unless row[9].nil?
        im.procedure = row[10] unless row[10].nil?

        if im.changed.present?
##          p '** ' + indicador.code.to_s + '/' + indicador.id.to_s + ' ' + in_out.to_s + ' ' + indicador.item.description + ' ' + im.data_source.to_s
          if ENV['save'] == 'true'
            im.save
            count_updated += 1
          end
        end
      end
    end

    p 'FINALIZA EL PROCESO'
    p '  Indicadores leidos:                 '  + count_read.to_s
    p '  Indicadores actualizados:           '  + count_updated.to_s
    p '  Errores:                            '  + (count_error_indicator + count_error_indicator_metric).to_s
    p '    Indicador blanco:                 '  + count_no_indicator.to_s
    p '    Indicadores no encontrados:       '  + count_error_indicator.to_s
    p '    Indicador_metrics no encontrados: '  + count_error_indicator_metric.to_s
  end

end

