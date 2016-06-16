namespace :import do
  require 'spreadsheet'

  desc "Import process structure"
  task procesos: :environment do
    puts " Realizando carga de procesos de Distritos ..... "
    cargar_cambios
    file = "../procesos_distritos_2015.xls"
    libro = Spreadsheet.open file
    @first_time = true
    @deb = false
    @process_structure = true
    init_log
    cab_log
    init_log
    clear_data
    (10000002..10000022).each  do |o|
    # Procesando las hojas de los departamentos
    puts "\n***** procesando #{o} "
      @sap_id = o
      (3..10).each do |i|
         hoja = libro.worksheet i
         process_sheet(hoja, file)
       end
     end
     puts "Finalizada importación de procesos de distritos."
  end

  desc "Import organizations entry data"
  task indicadores: :environment do
      puts " Realizando carga de indicadores de Distritos ..... "
      init_log
      cab_log
      cargar_cambios
     @process_structure = false
    Dir["../CargasDistritos/*.xls"].each do |file|
      puts "\n ***  #{file} ***"
      libro = Spreadsheet.open file
      @sap_id = File.basename(file)[0,8]
      @first_time = true
      @deb = false

    # Procesando las hojas de los departamentos
      (3..10).each do |i|
         hoja = libro.worksheet i
         process_sheet(hoja, file)
       end
    end
    puts "Finalizada importación de indicadores de distritos."
  end

  desc "import units"
  task distritos: :environment do
#   Rake::Task["db:seed"].execute
    file_name = "../UnidadesDistritos.xls"
    libro = Spreadsheet.open file_name

    # Procesando las hojas de los departamentos
    (0..8).each do |i|
       hoja = libro.worksheet i
       @num = 0
       process_units(hoja, i)
       puts "Creando: #{hoja.name} - nº: #{@num}"
     end
   end
end


