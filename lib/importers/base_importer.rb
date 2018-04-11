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
      ret = parse
      notify_admin(ret)
      Rails.logger.info (self.class.to_s + ' - '  +  Time.zone.now.to_s + " - Fin de proceso:")
    end

    def notify_admin(ret)
      message =  ret.blank? ? '*** notify_Admin **** ERROR: ejecutando importer - revisar log  ' : '*** notify_Admin **** OK: Ejecutado importer'
      Rails.logger.info(self.class.to_s + ' - '  +  message)
    end

    def open_spreadsheet
      begin
        case @extname
          when ".csv" then Roo::Csv.new(@filepath, nil, :ignore)
          when ".xls" then Roo::Excel.new(@filepath)
          when ".xlsx" then Roo::Excelx.new(@filepath)
          else raise " - Tipo de archivo no permitido: #{@filepath}"
        end
      rescue StandardError => e
        Rails.logger.info(self.class.to_s + ' - '  +  e.message)
        false
      end
    end

    def delete_file
      if File.delete(@filepath)
        Rails.logger.info (self.class.to_s + ' - '  +  Time.zone.now.to_s + " - Eliminado fichero de RPT:   #{@filepath}" )
      end
    end
  end
end
