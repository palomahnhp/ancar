namespace :rpt do
  require 'roo'

  desc "Cargar datos de RPT"
  task carga: :environment do
    if (ENV['year'].blank? || ENV['organization_id']).blank?
      puts 'Error: mandatory parameters year and unit_id'
      return
    end
    year    = ENV['year']
    organization_id = ENV['organization_id']
    path = '/home/phn001/Documents/carga/SGTDesarrolloUrbano.xlsx'
    path = ENV['file'] if ENV['file'].present?
    begin
      rpt_file = Roo::Spreadsheet.open(path)
    rescue IOError => e
      Rails.logger.info('Error RPT:LOAD: ' + e.to_s)
    end
    unless e.present?
      rpt_file.each_with_index do |col, index|
        if index == 0
          @columnas = col
          Rpt.where(organization_id: organization_id, year: year).delete_all
          next
        end
        @rpt = Rpt.create(organization_id: organization_id, year: year)
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
end