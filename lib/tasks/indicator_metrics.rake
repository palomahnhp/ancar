namespace :indicator_metrics do
  require 'spreadsheet'

  desc "Initialize in_out_type"
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
  task validate_JD_data: :environment do
    count_read = count_data = count_validation_error = count_no_indicator = count_error_indicator = count_error_indicator_metric = count_updated =  0
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
        fila = row.idx
        fila += 1
        indicator_ant  = @indicator_code
        desc_ant       = @indicator_desc

        @indicator_code    = row[0]
        indicator_in_out  = row[1]
        @indicator_desc    = row[2]
        metric_desc       = row[3].nil? ? '' : row[3]
        source_desc       = row[4].nil? ? '' : row[4]
        indicator_automatic = row[5].nil? ? '' : row[5]
        indicator_data_source = row[9]
        indicator_proc    = row[10]

        @indicator_code = 0 if @indicator_code.nil?

        next unless @indicator_code.is_a? Numeric
        count_read += 1

        if @indicator_code == 0
          @indicator_code = indicator_ant
#           p '  ** WARNING ' + fila.to_s + ': ** Num Indicador a blanco: se toma el del anterior' + @indicator_code.to_s + indicator_in_out.to_s + @indicator_desc.to_s
          if @indicator_desc.nil?
            @indicator_desc = desc_ant
#           p '  ** WARNING ' + fila.to_s + ': ** Desc Indicador a blanco: se toma el del anterior' + @indicator_code.to_s + indicator_in_out.to_s + @indicator_desc.to_s
          end
        end

        if @indicator_code == 0
          p '  ** ERROR ' + fila.to_s + ' *** Num Indicador a blanco: ' + @indicator_code.to_s + indicator_in_out.to_s + @indicator_desc.to_s
          count_no_indicator += 1
          next
        end

        indicators = Indicator.where(code: @indicator_code.to_i)

        indicador = nil
        indicators.each do |ind|
          indicador = ind if ind.period == period
        end

        in_out = row[1]

        if indicador.nil?
          p '  ** ERROR ' + fila.to_s + ' *** No encontrado indicator code in_out: ' + @indicator_code.to_i.to_s + '/'+ in_out.to_s
          count_error_indicator += 1
          next
        end

        im = IndicatorMetric.where(indicator_id: indicador.id, in_out_type: in_out).take
        if im.nil?
          p '  ** ERROR ' + fila.to_s + ' *** No encontrado indicator metric para indicator in_out: ' + indicador.code.to_s + '/' + indicador.id.to_s + '/' + in_out.to_s
          count_error_indicator_metric += 1
          next
        end

        if ENV['validation'] == 'true'
          msj = []
          if im.in_out_type != indicator_in_out then msj << "  ** ERROR @indicator_in_out #{im.in_out_type} / #{indicator.in_out}" end
#          if indicador.item.description.upcase != @indicator_desc.squish.upcase then msj << "  ** ERROR @indicator_desc #{indicador.item.description.upcase} / #{@indicator_desc.squish.upcase}" end
#          if im.metric.item.description.upcase != metric_desc.squish.upcase then msj << "  ** ERROR metric #{im.metric.item.description.upcase} / #{metric_desc.squish.upcase}" end

          if im.indicator_sources.present? && im.indicator_sources.first.source.present?
            if im.indicator_sources.first.source.item.description.upcase != source_desc.upcase &&  im.indicator_sources.first.source.item.description.upcase.split(/\W+/)[0] != source_desc.upcase.squish
               msj << "  ** ERROR source #{im.indicator_sources.first.source.item.description.upcase} / #{source_desc.upcase}"
            end

            if im.indicator_sources.first.source.fixed.present? && indicator_automatic.squish != 'A'
              msj << "  ** ERROR fuente automatica #{im.indicator_sources.first.source.fixed.present?} #{indicator_automatic.squish}"
            end
            if im.indicator_sources.first.source.fixed.present? && indicator_automatic.squish == '' then msj << "  ** ERROR fuente NO automatica #{im.indicator_sources.first.source.fixed.present?} #{indicator_automatic.squish}" end
          else
            msj << "  ** ERROR no tiene fuente"
          end

          if im.data_source.to_s != indicator_data_source.to_s
            msj << "  ** ERROR indicator_metric modo obtención  id=#{im} / #{im.data_source} / #{indicator_data_source}"
          end
          if im.procedure != indicator_proc then msj << "  ** ERROR indicator tramite #{im.procedure} / #{indicator_proc}" end
          if msj.present?
            p 'tratando fila: ' + fila.to_s + ' ' + row.to_s
            p msj
            count_validation_error += 1
          end
        else
          im.data_source = indicator_data_source unless indicator_data_source.nil?
          im.procedure = indicator_proc unless indicator_proc.nil?
          count_data += 1
          if im.changed.present?
            p '** ' + indicador.code.to_s + '/' + indicador.id.to_s + ' ' + in_out.to_s + ' ' + indicador.item.description + ' ' + im.data_source.to_s
            if ENV['save'] == 'true'
              im.save
              count_updated += 1
            end
          end
        end
      end
    end

    p 'FINALIZA EL PROCESO'
    p '  Indicadores leidos:                 '  + count_read.to_s
    p '              encontrados:            '  + count_data.to_s
    p '  Indcicadores con errores de validación: ' + count_validation_error.to_s
    p '  Indicadores actualizados:           '  + count_updated.to_s
    p '  Errores:                            '  + (count_error_indicator + count_error_indicator_metric).to_s
    p '    Indicador blanco:                 '  + count_no_indicator.to_s
    p '    Indicadores no encontrados:       '  + count_error_indicator.to_s
    p '    Indicador_metrics no encontrados: '  + count_error_indicator_metric.to_s
  end

end

