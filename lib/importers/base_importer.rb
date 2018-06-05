module Importers
  class BaseImporter
    attr_reader :filepath

    def initialize(year, extname, filepath)
      @year     = year
      @filepath = filepath
      @extname  = extname
    end

    def run
      PublicActivity.enabled = false
      activity_log(self.class, "Inicio con parámetros:  #{@year} / #{@filepath}", :info)
      parse
      notify_admin
      activity_log(self.class, "Fin de proceso:", :info)
      PublicActivity.enabled = true
    end

    private

    def notify_admin
      begin
        AdminMailer.importer_email(message: 'Termina el proceso de importación ' + @year + ' ' + @filepath).deliver_now  # deliver_later
      rescue StandardError => e
        Rails.logger.error(self.class.to_s + ' - '  +  e.message)
      end
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
      File.delete(@filepath)
    end

    def activity_log(class_name, message, type)
      class_name.to_s.create_activity :create, owner: current_user, parameters:  "#{@year} / #{@filepath}"
      log_message = class_name.to_s + ' - ' + Time.zone.now.to_s + ' - ' + message
      if type == :error
        Rails.logger.error log_message
      else
        Rails.logger.info  log_message
      end
    end
  end
end
