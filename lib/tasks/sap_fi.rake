namespace :sap_fi do
  require 'spreadsheet'

  desc "Cargar capitulos"
  task load_chapters: :environment do
    if ENV['year'].nil?
      p '**'
      p '** ERROR: debe indicar year : rake sap_fi:load_chapter year=2016'
      p '**'
      exit
    end

    if ENV['save'] && ENV['save'] == 'true'
      BudgetExecution.where(year: ENV['year']).destroy_all
    end
    BudgetChapter.new(year: ENV['year'], code: '1', description: 'GASTOS DE PERSONAL' ).save if ENV['save'] && ENV['save'] == 'true'
    BudgetChapter.new(year: ENV['year'], code: '2', description: 'GASTOS EN BIENES CORRIENTES Y SERVICIOS').save if ENV['save'] && ENV['save'] == 'true'
    BudgetChapter.new(year: ENV['year'], code: '3', description: 'GASTOS FINANCIEROS ').save if ENV['save'] && ENV['save'] == 'true'
    BudgetChapter.new(year: ENV['year'], code: '4', description: 'TRANSFERENCIAS CORRIENTES ').save if ENV['save'] && ENV['save'] == 'true'
    BudgetChapter.new(year: ENV['year'], code: '6', description: 'INVERSIONES REALES').save if ENV['save'] && ENV['save'] == 'true'
    BudgetChapter.new(year: ENV['year'], code: '7', description: 'TRANSFERENCIAS DE CAPITAL').save if ENV['save'] && ENV['save'] == 'true'
    BudgetChapter.new(year: ENV['year'], code: '8', description: 'ACTIVOS FINANCIEROS').save if ENV['save'] && ENV['save'] == 'true'
    BudgetChapter.new(year: ENV['year'], code: '9', description: 'PASIVOS FINANCIEROS').save if ENV['save'] && ENV['save'] == 'true'
  end

  desc "Cargar resppnsable programa."
  task update_responsable: :environment do
    if ENV['filename'].nil? || ENV['year'].nil?
      p '**'
      p '** ERROR: debe indicar year file: rake sap_fi:format_budget year=2916 filename=../nombrefichero.xls'
      p '**'
      exit
    end

    p 'Loading  manager programs ...  '  + ', file: ' +ENV['filename']
    book  = Spreadsheet.open ENV['filename']
    sheet = book.worksheet 2
    sheet.rows.each do |row|
      next if row.idx == 0 || row[6].nil?
      program = BudgetProgram.find_by_year_and_code(row[1], row[2])
      program.organization = Organization.find_by_description(row[6])
      program.save
    end
  end

  desc "Formatear alv de ejecucion presupuesto."
  task format_budget_execution: :environment do
    if ENV['filename'].nil? || ENV['year'].nil?
      p '**'
      p '** ERROR: debe indicar year file: rake sap_fi:format_budget year=2916 filename=../nombrefichero.xls'
      p '**'
      exit
    end

    p 'Formating budget executions excel ...  '  + ', fichero: ' +ENV['filename']
    book  = Spreadsheet.open ENV['filename']

    @indicator_metrics = Hash.new
    # Inicializar para el año- orden sections, programs, executions por referencias
    if ENV['save'] && ENV['save'] == 'true'
      if ENV['load_execution'] && ENV['load_execution'] == 'true'
        BudgetExecution.where(year: ENV['year']).destroy_all
      elsif ENV['load_programs'] && ENV['load_programs'] == 'true'
        BudgetExecution.where(year: ENV['year']).destroy_all
        BudgetProgram.where(year: ENV['year']).destroy_all
      elsif ENV['load_sections'] && ENV['load_sections'] == 'true'
        BudgetExecution.where(year: ENV['year']).destroy_all
        BudgetProgram.where(year: ENV['year']).destroy_all
        BudgetSection.where(year: ENV['year']).destroy_all
      end
    end

    # proceso del libro
    (0..(book.worksheets.count-1)).each do |i|
      sheet = book.worksheet i
      seccion = sheet.name

      p 'Procesando Sección: ' + seccion

      # Cargando secciones
      if ENV['load_sections'] && ENV['load_sections'] == 'true'
        section_code = sheet.rows[11][1][33..35]
        section_description = sheet.rows[11][1][51..(sheet.rows[11][1].length-1)]
          print ' ' + section_description
          if ENV['save'] && ENV['save'] == 'true'
            BudgetSection.create(year: ENV['year'], code: section_code, description: section_description)
            p '... created'
          else
            p ' ... test'
          end
        next
      end

      (sheet.rows).each do |row|
        # Cargando programas
        if ENV['load_programs'] && ENV['load_programs'] == 'true'
          next if row[0].nil?
          code = row[1][0..4]
          description = description = row[1][7..row[1].length-1 ]
          print 'Tratando programa: ' + code + ' ' + description
          if ENV['save'] && ENV['save'] == 'true'
            program = BudgetProgram.find_or_create_by(year: ENV['year'], code: code, description: description,
            budget_section: BudgetSection.find_by_code_and_year(sheet.name, ENV['year']) )
            p ' ... ' + 'saved'
          else
            p ' ... ' + 'test'
          end

        # Cargando ejecución el presupuesto
        elsif ENV['load_execution'] && ENV['load_execution'] == 'true'
          @program = row[1][0..4] if row[0] == 'P'
          next if row[1].nil? || row[0] == 'P'
          economic_code = row[1][0..4]
          next unless economic_code.to_i > 10  && (economic_code.to_i.is_a? Integer)
          print '  processing row ' + row.idx.to_s + ' ' + row[1]

          execution_line = BudgetExecution.new()

          execution_line.year = ENV['year']
          execution_line.economic_description = row[1][7..row[1].length-1 ]
          execution_line.economic_code = economic_code

          execution_line.budget_section= BudgetSection.find_by_code_and_year(sheet.name, ENV['year'])
          execution_line.budget_chapter = BudgetChapter.find_by_code(economic_code[0])
          execution_line.budget_program = BudgetProgram.find_by_code(@program)

          execution_line.credit_initial     =  row[2].gsub(',', '.') if row[2].to_i > 0
          execution_line.credit_modification =  row[3].gsub(',', '.') if row[3].to_i > 0
          execution_line.credit_definitive  =  row[4].gsub(',', '.') if row[4].to_i > 0
          execution_line.credit_available   =  row[5].gsub(',', '.') if row[5].to_i > 0
          execution_line.credit_authorized  =  row[7].gsub(',', '.') if row[7].to_i > 0
          execution_line.credit_willing     =  row[9].gsub(',', '.') if row[9].to_i > 0
          execution_line.obligation_recognized = row[11].gsub(',', '.') if row[11].to_i > 0
          execution_line.payment_ordered    =  row[13].gsub(',', '.') if row[13].to_i > 0
          execution_line.payment_performed  =  row[14].gsub(',', '.') if row[14].to_i > 0

          if ENV['save'] && ENV['save'] == 'true'
            if execution_line.save
              p ' ... ' + 'saved'
            end
          end
        end
      end
    end
   end

  desc "Extracción indicadores."
  task indicators: :environment do
    if ENV['year'].nil?
      p '**'
      p '** ERROR: debe indicar year file: rake sap_fi:format_budget year=2916 filename=../nombrefichero.xls'
      p '**'
      exit
    end
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet name: 'Indicadores'
    sheet1.row(0).concat %w{INDICADOR ID_ORG ORGANIZACION SECCIÓN PROGRAMA CAPÍTULO ECONÓMICO CANTIDAD}

    reg = Hash.new
    fila = 1
    OrganizationType.find_by_acronym('SGT').organizations.each do |org|
      org.budget_programs.where(year: ENV['year']).each do |pgm|
        # INDICADOR 2.7 MATERIAL OFICINA
        BudgetExecution.where(year: ENV['year'], budget_program: pgm, budget_section_id: pgm.budget_section_id,
                              economic_code: '22000' ).each do |exec|

          sheet1[fila ,0] = '2.7'
          sheet1[fila,1] = org.id
          sheet1[fila,2] = org.description
          sheet1[fila,3] = pgm.budget_section.code + ' ' + pgm.budget_section.description
          sheet1[fila,4] = pgm.code  + ' ' + pgm.description
          sheet1[fila,5] = exec.budget_chapter.code  + ' ' + exec.budget_chapter.description
          sheet1[fila,6] = exec.economic_code  + ' ' + exec.economic_description
          sheet1[fila,7] = exec.payment_performed
          fila += 1
        end
        programas = 0

        # INDICADOR 3.2 Coordinación de las propuestas de las Direcciones Generales
        #  3.2.1 importe programas
        BudgetExecution.where(year: ENV['year'], budget_program: pgm, budget_section_id: pgm.budget_section_id).each do |exec|
          next if exec.budget_chapter_id == 1
          sheet1[fila,0] = '3.2.1'
          sheet1[fila,1] = org.id
          sheet1[fila,2] = org.description
          sheet1[fila,3] = pgm.budget_section.code + ' ' + pgm.budget_section.description
          sheet1[fila,4] = pgm.code  + ' ' + pgm.description
          sheet1[fila,5] = exec.budget_chapter.code  + ' ' + exec.budget_chapter.description
          sheet1[fila,6] = exec.economic_code  + ' ' + exec.economic_description
          sheet1[fila,7] = exec.payment_performed
          fila += 1
          programas += 1
        end

        #  3.2.2 número programas
          sheet1[fila,0] = '3.2.2'
          sheet1[fila,1] = org.id
          sheet1[fila,2] = org.description
          sheet1[fila,3] = pgm.budget_section.code + ' ' + pgm.budget_section.description
          sheet1[fila,4] = ' '
          sheet1[fila,5] = ' '
          sheet1[fila,6] = ' '
          sheet1[fila,7] = programas
          fila += 1

        # INDICADOR 9.3. Contratación
        #  8.3.2 importe prsuupuesto Área
        BudgetExecution.where(year: ENV['year'], budget_program: pgm, budget_section_id: pgm.budget_section_id).each do |exec|
          sheet1[fila,0] = '8.3.2'
          sheet1[fila,1] = org.id
          sheet1[fila,2] = org.description
          sheet1[fila,3] = pgm.budget_section.code + ' ' + pgm.budget_section.description
          sheet1[fila,4] = pgm.code  + ' ' + pgm.description
          sheet1[fila,5] = exec.budget_chapter.code  + ' ' + exec.budget_chapter.description
          sheet1[fila,6] = exec.economic_code  + ' ' + exec.economic_description
          sheet1[fila,7] = exec.payment_performed
          fila += 1
        end

        # INDICADOR 3.1 Propuesta de Presupuesto anual de la SGT
        # 3.1 importe
        BudgetExecution.where(year: ENV['year'], budget_program: pgm, budget_section_id: pgm.budget_section_id).each do |exec|
          next if exec.budget_chapter_id == 1
          sheet1[fila,0] = '3.1'
          sheet1[fila,1] = org.id
          sheet1[fila,2] = org.description
          sheet1[fila,3] = pgm.budget_section.code + ' ' + pgm.budget_section.description
          sheet1[fila,4] = pgm.code  + ' ' + pgm.description
          sheet1[fila,5] = exec.budget_chapter.code  + ' ' + exec.budget_chapter.description
          sheet1[fila,6] = exec.economic_code  + ' ' + exec.economic_description
          sheet1[fila,7] = exec.credit_initial
          fila += 1
        end

      end
    end

    book.write ENV['filename']
  end

end

