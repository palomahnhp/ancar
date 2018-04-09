class UnitRptAssignationImporter
  attr_reader :filepath

  def initialize(year, extname, filepath)
    @year     = year
    @filepath = filepath
    @extname  = extname
  end

  def run
    Rails.logger.info ('*** ' + Time.zone.now.to_s + " - Inicio de importación de Assignación de unidades:  #{@year} / #{@filepath}")
    parse
    notify_admin
    Rails.logger.info ('*** ' + Time.zone.now.to_s + " - Fin de importación de Assignación de unidades:  #{@year} / #{@filepath}")
  end

  def parse
    spreadsheet = open_spreadsheet
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
        Rails.logger.info { "No se actualiza el registro " + i.to_s + row["denominacion"] + unit_assignation.errors.messages.to_s }
      end
    end

    if File.delete(@filepath)
      Rails.logger.info ('*** ' + Time.zone.now.to_s + " - Eliminado fichero:   #{@filepath}" )
    end
  end

  private

  def notify_admin
    if @start.blank?
      puts '*** notify_Admin **** Ejecutando UnitAssignationImporter '
      @start = true
    else
      puts '*** notify_Admin **** Ejecutado UnitAssignationImporter '
    end
  end

  def open_spreadsheet
    puts Time.zone.now.to_s + ': RPT.import - open_spreadsheet - params: extname ' + @extname + ', path ' + @filepath
    case @extname
      when ".csv" then Roo::Csv.new(@filepath, nil, :ignore)
      when ".xls" then Roo::Excel.new(@filepath)
      when ".xlsx" then Roo::Excelx.new(@filepath)
      else raise "Unknown file type:" + @filepath + ' - ' + @extname
    end
  end
end
