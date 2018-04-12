module Importers
  class BaseImporter
    attr_reader :filepath

    def initialize(year, extname, filename, filepath)
      @year     = year
      @filename = filename
      @filepath = filepath
      @extname  = extname
    end

    def run
      activity_log(self.class, "Inicio con parámetros:  #{@year} / #{@filename}", :info)
      parse
      notify_admin
      activity_log(self.class, "Fin de proceso:", :info)
    end

    private

    def notify_admin
      AdminMailer.importer_email(message: 'Termina el proceso de importación ' + @year + ' ' + @filename).deliver_now  #deliver_later
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
        activity_log(self.class, "Eliminado fichero tmp:   #{@filepath}", :info )
      end
    end

    def activity_log(class_name, message, type)
      log_message = class_name.to_s + ' - ' + Time.zone.now.to_s + ' - ' + message
      if type == :error
        Rails.logger.error log_message
      else
        Rails.logger.info  log_message
      end
    end

  end
end