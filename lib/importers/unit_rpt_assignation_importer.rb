module Importers
  class UnitRptAssignationImporter  < BaseImporter

    def parse
      spreadsheet = open_spreadsheet
      activity_log(self.class, "comienza lectura fichero: #{@filepath}", :info)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        unit_assignation = UnitRptAssignation.find_or_create_by(year: @year, sapid_unit: row["id_unidad"])
        unit_assignation.den_unit = row["denominacion"]
        if row["id_unit"].present?
          unit_assignation.unit         = Unit.find_by(sap_id: row["id_unit"])
          unit_assignation.organization = unit_assignation.unit.organization
        else
          unit_assignation.organization = FirstLevelUnit.find_by(sapid_unit: row["id_area"]).organization
        end
        begin
          unit_assignation.save!
        rescue
          activity_log(self.class, "No se actualiza el registro " + i.to_s + row["denominacion"] +
                           unit_assignation.errors.messages.to_s, :error)
        end
      end
      delete_file
      activity_log(self.class,  "Termina la importación de " + @filename ,:info)

    end
  end
end
