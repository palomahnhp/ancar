class Rpt < ActiveRecord::Base
  belongs_to :organization
  belongs_to :unit

  validates_presence_of :year, :organization_id, :id_puesto

  scope :by_organization, ->(organization) { where( organization: organization ) }
  scope :by_unit,         ->(unit) { where( unit: unit ) }
  scope :by_unit_sap,     ->(unit) { where( sapid_unidad: unit ) }
  scope :by_year,         ->(year) { where( year: year ) }
  scope :vacant,          -> { where(ocupada: 'VC') }
  scope :occupied,        -> { where(ocupada: 'OC') }
  scope :a1,              -> { where(grtit_per: 'A1') }
  scope :a2,              -> { where(grtit_per: 'A2') }
  scope :c1,              -> { where(grtit_per: 'C1') }
  scope :c2,              -> { where(grtit_per: 'C2') }
  scope :e,               -> { where(grtit_per: 'E') }
  scope :nogrtit,         -> { where(grtit_per:   'X') }

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
      rpt = find_by(year: row["year"], sapid_organizacion: row["sapid_organizacion"],
                    sapid_unidad: row["sapid_unidad"], id_puesto: row["id_puesto"]) || new
      rpt.attributes   = row.to_hash
      rpt.organization = Organization.find_by(sap_id: row["sapid_organizacion"])
      rpt.unit         = Unit.find_by(sap_id: row["sapid_unidad"]).presence
      Rails.logger.info { "No se actualiza el registro " + i.to_s + row["den_organizacion"] } unless rpt.save
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