module Importers
  class UnitRptAssignationImporter < BaseImporter

    def parse
      Rpt.transaction do
        spreadsheet = open_spreadsheet
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          unit_assignation = init_reg(row)
          begin
            unit_assignation.save!
          rescue StandardError => e
            activity_log(self.class, 'No se actualiza el registro ' + i.to_s + row['denominacion'] +
                             unit_assignation.errors.messages.to_s + ' ' +  + e.message, :error)
          end
        end
        delete_file
      end
    end

    private

    def init_reg(row)
      unit_assignation = UnitRptAssignation.find_or_create_by(year: @year, sapid_unit: row['id_unidad'])
      unit_assignation.den_unit = row['denominacion']
      if row["id_unit"].present?
        unit_assignation.unit         = Unit.find_by(sap_id: row['id_unit'])
        unit_assignation.organization = unit_assignation.unit.organization
      else
        unit_assignation.organization = FirstLevelUnit.find_by(sapid_unit: row['id_area']).organization
      end
      unit_assignation
    end
  end
end
