class UnitRptAssignation < ActiveRecord::Base

  belongs_to :unit
  belongs_to :organization

  scope :by_year,         ->(year) { where( year: year ) }
  scope :by_organization, ->(organization) { where( organization: organization ) }
  scope :by_unit,         ->(unit) { where( unit: unit ) }
  scope :by_year_and_organization, ->(year, organization) { where( year: year, organization: organization ) }
  scope :by_year_and_organization_without_unit, ->(year, organization) { where( year: year,
                                                                                organization:organization,
                                                                                unit: nil ) }

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
end
