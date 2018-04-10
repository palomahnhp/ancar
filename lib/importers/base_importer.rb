module Importers
  class BaseImporter
    attr_reader :filepath

    def initialize(year, extname, filepath)
      @year     = year
      @filepath = filepath
      @extname  = extname
    end

    def run
      Rails.logger.info (self.class.to_s + ' - '  + Time.zone.now.to_s + " - Inicio con parámetros:  #{@year} / #{@filepath}")
      parse
      notify_admin
      Rails.logger.info (self.class.to_s + ' - '  +  Time.zone.now.to_s + " - Fin de proceso:")
    end

    private

    def notify_admin
      if @start.blank?
        puts '*** notify_Admin **** Ejecutado importer '
        @start = true
      else
        puts '*** notify_Admin **** Ejecutado importer '
      end
    end

    def open_spreadsheet
      case @extname
        when ".csv" then Roo::Csv.new(@filepath, nil, :ignore)
        when ".xls" then Roo::Excel.new(@filepath)
        when ".xlsx" then Roo::Excelx.new(@filepath)
        else raise "Unknown file type: #{@filepath}"
      end
    end

    def delete_file
      if File.delete(@filepath)
        Rails.logger.info (self.class.to_s + ' - '  +  Time.zone.now.to_s + " - Eliminado fichero de RPT:   #{@filepath}" )
      end
    end
  end
end
