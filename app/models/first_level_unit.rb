class FirstLevelUnit < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  belongs_to :organization

  scope :active,   -> { where(period_to: nil ) }

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      unit = find_by(period_from: row["period_from"], sapid_unit: row["sapid_unit"], den_unit: row["den_unit"]) || new
      unit.attributes   = row.to_hash
      unit.organization = Organization.find_by(sap_id: row["organization_id"])
      Rails.logger.info { "No se actualiza el registro " + i.to_s + row["den_unit"] + unit.errors.messages.to_s } unless unit.save
    end
    true
  end

  private

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
