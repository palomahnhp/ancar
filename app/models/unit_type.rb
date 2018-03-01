class UnitType < ActiveRecord::Base
  has_many :sub_processes
  has_many :units
  belongs_to :organization_type

  def self.select_options(organization_type='')
    return UnitType.all.collect { |v| [ v.description, v.id ] } unless organization_type.present?
    UnitType.where(organization_type_id: organization_type.id).collect { |v| [ v.description, v.id ] }
  end
end
