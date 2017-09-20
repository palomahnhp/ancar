namespace :entry_indicators do
  require 'spreadsheet'

  desc "Importar entry_indicators"
  task import_SGT: :environment do
    if ENV['period'].nil? || ENV['filename'].nil? || ENV['save'].nil?
      p '**'
      p '** ERROR: debe indicar id del periodo y file: rake entry_indicators:import period=10 filename=../nombrefichero.xls'
      p '**'
      exit
    end

    period = Period.find(ENV['period'].to_i)
    p 'Importing entry_indicators: ' + ' actualización: ' + ENV['save'] + ' ' +period.description + ', fichero: ' +ENV['filename']

    book  = Spreadsheet.open ENV['filename']
    sheet = book.worksheet 0
    @indicator_metrics = Hash.new

    (sheet.rows).each do |row|
      next if row[0].nil?
      # Obtiene los entry_indicadores a cargar
      if row[0] == 'INDICADORES'
        (3..(row.count-1)).each do |n|
          @indicator_metrics[n] =  row[n] if row[n].integer?
        end
        next
      end

      # Trata cada SGT
      data = Hash.new
      data['period_id'] = period.id
      data['unit_id'] = row[1].to_i
      p 'Tratando Unidad: ' + data['unit_id'].to_s

      @indicator_metrics.to_a.each do |indicator_metric|
        data['indicator_metric'] = indicator_metric[1]
        data['amount'] = row[indicator_metric[0]]
        data['imported_amount'] = row[indicator_metric[0]]
        data['updated_by'] = 'import'
        p " * Tratando indicator: " + data.to_s

        if data['amount'].nil?
          p '  ** AMOUNT  nulo, registro no se trata'
          next
        end

        entry_indicator = EntryIndicator.create_from_import(data)
        if ENV['save'] == 'true'
          if entry_indicator.save
            p "  ** Creado entry_indicator: " + entry_indicator.indicator_metric.id.to_s + ' - ' + entry_indicator.indicator_metric.metric.item.description
          else
            p "  ** ERROR no creado entry_indicator: " + entry_indicator.indicator_metric.id.to_s + ' - ' + entry_indicator.indicator_metric.metric.item.description
          end
        end
      end
    end
  end

  desc "Importar entry_indicators para distritos formato BI"
  task import_JD_BI: :environment do
    if ENV['period'].nil? || ENV['filename'].nil?
      p '**'
      p '** ERROR: debe indicar id del periodo y file: rake entry_indicators:import period=10 filename=../nombrefichero.xls'
      p '**'
      exit
    end
    period = Period.find(ENV['period'].to_i)
    p 'Importing entry_indicators: ' + ' actualización: ' +  ENV['save']+ ' ' +period.description + ', fichero: ' +ENV['filename']
    book  = Spreadsheet.open ENV['filename']
    sheet = book.worksheet 0
    (sheet.rows).each do |row|
      print '.'
      next if row[0] == 'Nº Indicador'
      data = Hash.new
      data['period_id'] = period.id
      indicators = Indicator.where(code: row[0].to_i)
      indicator = nil
      indicators.each do |ind|
        indicator = ind if ind.period == period
      end
      if indicator.present?
        organization_id = row[2].to_i
        unit_type_id = indicator.sub_process.unit_type_id
        data['unit_id'] = Unit.where(organization_id: organization_id, unit_type_id: unit_type_id).take.id
        data['indicator_metric'] = IndicatorMetric.where(indicator_id: indicator.id).take.id
        data['amount'] = row[5]
        data['imported_amount'] = row[5]
        data['updated_by'] = 'import'
#        p " * Tratando indicator: " + data.to_s
        if data['amount'].nil?
          p '  ** AMOUNT  nulo, registro no se trata'
          next
        end
        entry_indicator = EntryIndicator.create_from_import(data)
        if ENV['save'] == 'true'
          if  entry_indicator.save
#            p '  ** Creado entry_indicator: ' + entry_indicator.indicator_metric.id.to_s + ' - ' + entry_indicator.indicator_metric.metric.item.description
          else
            p '  ** ERROR no creado entry_indicator: ' + entry_indicator.indicator_metric.id.to_s + ' - ' + entry_indicator.indicator_metric.metric.item.description
          end
        end
      else
        p ' ***** ERROR no se ha encontrado ese indicador en el periodo tratado: ' + row[0].to_s +  data.to_s
      end
    end
  end

  desc 'importación de indicadores para distritos desde excel SIGSA'
  task import_JD_SIGSA: :environment do
    count_read = count_no_indicator = count_no_indicator_metric = count_create = count_no_organization = count_no_entry_indicator = count_amount_nulo  =  0
    if ENV['period'].nil? || ENV['filename'].nil? || ENV['save'].nil?
      p '**'
      p '** ERROR: debe indicar id del periodo y file: rake entry_indicators:import period=10 filename=../nombrefichero.xls'
      p '**'
      exit
    end
    period = Period.find(ENV['period'].to_i)
    p 'Importing entry_indicators: ' + ENV['RAILS_ENV'].to_s + ' actualizaciOn: '+ ENV['save'] + ' ' + period.description + ', fichero: ' +ENV['filename']
    book  = Spreadsheet.open ENV['filename']
    (0..3).each do |i|
      sheet = book.worksheet i
      p sheet.name
      (sheet.rows).each do |row|
        next if row[0] == 'Num. Indicador '
        data = Hash.new
        indicador = row[0][0...4].to_i
        data['period_id'] = period.id
        indicators = Indicator.where(code: indicador)
        indicator = nil
        indicators.each do |ind|
          indicator = ind if ind.period == period
        end
        if indicator.present?
          (1..21).each do |i|
            organization = Organization.find_by_order(i)
            unit_type = indicator.sub_process.unit_type
            if organization.present? && unit_type.present?
              count_read += 1
              data['unit_id'] = Unit.where(organization_id: organization.id, unit_type_id: unit_type.id).take.id
              in_out = row[1]
              indicator_metric = IndicatorMetric.where(indicator_id: indicator.id, in_out_type: in_out)
              if indicator_metric.present?
                data['indicator_metric'] = indicator_metric.take.id
                data['amount'] = row[i+1].nil? ? 0 : row[i+1]
                data['imported_amount'] = data['amount']
                data['updated_by'] = 'import'

  #             p "**** Tratando indicator: " + data.to_s

                if data['amount'].nil?
                  p '  ** AMOUNT  nulo, registro no se trata: ' + indicator.item.description + ' ' +  in_out
                        organization.description + '/' + unit_type.description
                  count_amount_nulo += 1
                  next
                end
                entry_indicator = EntryIndicator.create_from_import(data)
                if ENV['save'] == 'true'
                  if entry_indicator.save
#                    p '  ** CREADO entry_indicator: ' + entry_indicator.indicator_metric.id.to_s + ' - ' + entry_indicator.indicator_metric.metric.item.description +
                           ' ' + organization.description + '/' + unit_type.description
                    count_create += 1
                  else
                    p '  ** ERROR en save no creado entry_indicator: ' + entry_indicator.indicator_metric.id.to_s + ' - ' + entry_indicator.indicator_metric.metric.item.description +
                           ' ' + organization.description + '/' + unit_type.description
                    count_no_entry_indicator += 1
                  end
                end
              else
                p '  ** ERROR No existe indicator metric para indicador ' + indicator.code.to_s + '/'+ indicator.id.to_s + '/' + indicator.item.description + ' entrada salida: ' + in_out +

                       ' ' + organization.description + '/' + unit_type.description
                count_no_indicator_metric += 1

              end
            else
              p '  ** ERROR obteniendo unit_type u organization: ' + i.to_s
              count_no_organization += 1
           end
          end
        else
          p ' ** ERROR no se ha encontrado ese indicador en el periodo tratado'
          count_no_indicator += 1
        end
      end
    end
    p 'FINALIZADO EL PROCESO: '
    p '-- Indicadores leidos:                ' + count_read.to_s
    p '-- Indicadores creados:               ' + count_create.to_s
    p '-- Indicadores con errores:           ' + (count_no_organization + count_no_indicator + count_no_indicator_metric +
        count_no_entry_indicator).to_s
    p '     Errores en organización o unidad : ' + count_no_organization.to_s
    p '     Errores en indicador:              ' + count_no_indicator.to_s
    p '     Errores en indicador_metric:       ' + count_no_indicator_metric.to_s
    p '     Errores en entry_indicador:        ' + count_no_entry_indicator.to_s

  end

end

