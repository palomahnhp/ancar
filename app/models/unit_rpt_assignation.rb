class UnitRptAssignation < ActiveRecord::Base

  belongs_to :unit
  belongs_to :organization

  scope :by_year,         ->(year) { where( year: year ) }
  scope :by_organization, ->(organization) { where( organization: organization ) }
  scope :by_unit,         ->(unit) { where( unit: unit ) }
  scope :by_year_and_organization, ->(year, organization) { where( year: year, organization: organization ) }
  scope :by_year_and_organization_without_unit, ->(year, organization) {
                                               where( year: year, organization: organization, unit: nil ) }

  def self.init(year)
    Organization.all.find_each do |organization|
      organization.rpts.select(:sapid_unidad).group(:sapid_unidad).each do |sap_unit|
        item = find_or_create_by!(year: year, organization: organization,
                                  sapid_unit: sap_unit.sapid_unidad,
                                  den_unit: Rpt.find_by(sapid_unidad: sap_unit.sapid_unidad).den_unidad )
        item.unit =  Unit.find_by(sap_id: sap_unit.sapid_unidad).presence if item.unit.blank?
        item.save
      end
    end
  end

  def self.copy(year)
    by_year(year - 1).each do |reg|
      reg.year = year
      reg.save
    end
  end

  def self.update(year, assigns)
    assigns.each do |assign|
      next if assign[1].blank?
      unit = find_by(sapid_unit: assign[0], year: year)
      unit.unit_id = assign[1]
      unit.save
    end
  end

  def self.import(year, file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      unit_assignation = find_or_create_by(year: year, sapid_unit: row["id_unidad"])
      unit_assignation.den_unit = row["denominacion"]
      if row["id_unit"].present?
        unit_assignation.unit         = Unit.find_by(sap_id: row["id_unit"])
        unit_assignation.organization = unit_assignation.unit.organization
      else
        unit_assignation.organization = FirstLevelUnit.find_by(sapid_unit: row["id_area"]).organization
      end
      puts 'i: ' + i.to_s
      Rails.logger.info { "No se actualiza el registro " + i.to_s + row["denominacion"] + unit_assignation.errors.messages.to_s } unless unit_assignation.save
    end
    true
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
