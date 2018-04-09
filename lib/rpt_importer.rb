class RptImporter
  attr_reader :filepath

  def initialize(year, extname, filepath)
    @year     = year
    @filepath = filepath
    @extname  = extname
  end

  def run
    Rails.logger.info ('*** ' + Time.zone.now.to_s + " - Inicio con parámetros:  #{@year} / #{@filepath}")
    parse
    notify_admin
    Rails.logger.info ('*** ' + Time.zone.now.to_s + " - Fin de proceso:")
  end

  def parse
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      rpt = Rpt.find_or_create_by(year: row["year"], sapid_area: row["sapid_area"],
                    sapid_unidad: row["sapid_unidad"], id_puesto: row["id_puesto"])
      rpt.attributes   = row.to_hash
      rpt.organization = FirstLevelUnit.find_by(sapid_unit: row["sapid_area"]).organization
      rpt.unit         = Unit.find_by(sap_id: row["sapid_unidad"]).presence
      begin
        rpt.save!
      rescue
        Rails.logger.info ('*** ' + Time.zone.now.to_s + " - Error actualizando RPT:   #{@filepath}" +
                          rpt.errors.to_s)
      end
    end

    if File.delete(@filepath)
      Rails.logger.info ('*** ' + Time.zone.now.to_s + " - Eliminado fichero de RPT:   #{@filepath}" )
    end
  end

  private

  def notify_admin
    if @start.blank?
      puts '*** notify_Admin **** Ejecutadondo importer '
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
end
