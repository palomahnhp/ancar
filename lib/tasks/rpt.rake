namespace :rpt do
  require 'roo'

  desc "Cargar datos de RPT"
  task carga: :environment do
    if (ENV['year'].blank? || ENV['unit_id']).blank?
      puts 'Error: mandatory parameters year and unit_id'
    else
      year    = ENV['year']
      unit_id = ENV['unit_id']
    end
    rpt_file = Roo::Spreadsheet.open('/home/phn001/Documents/carga/SGTDesarrolloUrbano.xlsx')

    rpt_file.each_with_index do |col, index|
      if index == 0
        @columnas = col
        Rpt.where(unit_id: unit_id, year: year).delete_all
        next
      end
      @rpt = Rpt.create(unit_id: unit_id, year: year)
      params = {}
      (0...(col.count)).each do |i|
        field = @columnas[i]
        value = col[i]
        params[field.to_sym] = value
      end
      @rpt.assign_attributes(params)
      @rpt.save
    end
  end
end