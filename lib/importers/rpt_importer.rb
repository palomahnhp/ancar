module Importers
  class RptImporter < BaseImporter
    def parse
      Rpt.transaction do
        activity_log(self.class, 'comienza lectura fichero: ' + @filename + ' tmp: ' + @filepath, :info )
        spreadsheet = open_spreadsheet
        header = spreadsheet.row(1)
        delete_rpt

        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          check_year(row)
          rpt = init_reg(row)
          begin
            rpt.save!
          rescue StandardError => e
            activity_log(self.class, "Error actualizando RPT: #{@filename} tmp: + #{filepath} " + rpt.errors.to_s +
                e.message, :error)
          end
        end
        delete_file
      end
      activity_log(self.class, "Finaliza import de fichero: #{@filename}", :info)
    end

    private

    def init_reg(row)
      rpt = Rpt.find_or_create_by(year: @year, sapid_area: row["sapid_area"],
                                  sapid_unidad: row["sapid_unidad"], id_puesto: row["id_puesto"])
      rpt.attributes   = row.to_hash
      rpt.organization = FirstLevelUnit.find_by(sapid_unit: row["sapid_area"]).organization
      rpt.unit         = Unit.find_by(sap_id: row["sapid_unidad"]).presence
      rpt
    end

    def check_year(row)
      return unless @year.to_s ==  row["year"].to_s
      activity_log(self.class, "No coincide el año a cargar #{@year} con el excel #{row['year']}", :error)
      raise(self.class.to_s + ' - '  + Time.zone.now.to_s +
                " No coincide el año a cargar #{@year} con el excel #{row['year']}")
    end

    def delete_rpt
      Rpt.by_year(@year).destroy_all
    end
  end
end

