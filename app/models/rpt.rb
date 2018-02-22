class Rpt < ActiveRecord::Base

  belongs_to :organization
  belongs_to :unit


  validates_presence_of :year, :organization_id, :id_puesto

  scope :by_organization, ->(organization) { where( organization: organization ) }
  scope :by_unit,         ->(unit) { where( unit: unit ) }
  scope :by_organization_and_year, ->(organization, year) { where( organization_id: organization,
                                                                   year: year ) }
  scope :by_year,         ->(year) { where( year: year ) }
  scope :vacant,          -> { where(ocupada: 'VC') }
  scope :occupied,        -> { where(ocupada: 'OC') }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |rpt|
        csv << rpt.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    return false unless file.present?
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      rpt = find_by(year: row["year"],   sapid_organizacion: row["sapid_organizacion"],
                    sapid_unidad: row["sapid_unidad"], id_puesto: row["id_puesto"]) || new
      rpt.attributes   = row.to_hash
      rpt.organization = Organization.find_by(sap_id: row["sapid_organizacion"])
      rpt.unit         = Unit.find_by(sap_id: row["sapid_unidad"]).presence
      rpt.save!
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