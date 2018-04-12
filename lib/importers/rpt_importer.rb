module Importers
  class RptImporter < BaseImporter
    def parse
      activity_log(self.class, 'comienza lectura fichero: ' + @filename + ' tmp: ' + @filepath, :info )
      spreadsheet = open_spreadsheet
      activity_log(self.class, "fichero leido: #{@filepath} " + spreadsheet.last_row.to_s + ' filas' , :info )
      header = spreadsheet.row(1)

      Rpt.transaction do
        delete_rpt
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]

          unless @year.to_s ==  row["year"].to_s
            activity_log(self.class, "No coincide el año a cargar #{@year} con el excel #{row["year"]}", :error)
            raise(self.class.to_s + ' - '  + Time.zone.now.to_s +
                      " No coincide el año a cargar #{@year} con el excel #{row["year"]}")
          end

          rpt = Rpt.find_or_create_by(year: @year, sapid_area: row["sapid_area"],
                        sapid_unidad: row["sapid_unidad"], id_puesto: row["id_puesto"])
          rpt.attributes   = row.to_hash
          rpt.organization = FirstLevelUnit.find_by(sapid_unit: row["sapid_area"]).organization
          rpt.unit         = Unit.find_by(sap_id: row["sapid_unidad"]).presence
          activity_log(self.class, "procesado registro: " + i.to_s, :info)
          begin
            rpt.save!
          rescue
            activity_log(self.class, "Error actualizando RPT: #{@filename} tmp: + #{filepath}" + rpt.errors.to_s,
                         :error)
          end
        end
      end
      delete_file
      activity_log(self.class, "Finaliza import de fichero: #{@filename}",:info)

    end

    private

    def delete_rpt
      Rpt.by_year(@year).destroy_all
    end

  end

end

