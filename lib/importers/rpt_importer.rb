module Importers
  class RptImporter < BaseImporter
    def parse
      Rails.logger.info (self.class.to_s + ' - '  + Time.zone.now.to_s + " - comienza lectura fichero: #{@filepath}")
      spreadsheet = open_spreadsheet
      if spreadsheet.present?
        Rails.logger.info (self.class.to_s + ' - '  + Time.zone.now.to_s + " - fichero leido: #{@filepath} " +
            spreadsheet.last_row.to_s + ' filas' )
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          begin
            row = Hash[[header, spreadsheet.row(i)].transpose]
            rpt = Rpt.find_or_create_by(year: row["year"], sapid_area: row["sapid_area"],
                          sapid_unidad: row["sapid_unidad"], id_puesto: row["id_puesto"])
            rpt.attributes   = row.to_hash
            rpt.organization = FirstLevelUnit.find_by(sapid_unit: row["sapid_area"]).organization
            rpt.unit         = Unit.find_by(sap_id: row["sapid_unidad"]).presence
            Rails.logger.info (self.class.to_s + ' - '  + Time.zone.now.to_s + " - procesado registro: " + i.to_s)
            rpt.save!
          rescue StandardError => e
            Rails.logger.info(self.class.to_s + ' - '  +  " - Error parse RPT: #{@filepath}" + e.message)
            false
          end
        end
        delete_file
      else
        Rails.logger.info(self.class.to_s + ' - '  +  " - No se ha realizado la importación de : #{@filepath}")
        false
      end
    end
  end
end

