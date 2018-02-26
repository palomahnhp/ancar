class Organization < ActiveRecord::Base
  resourcify
  belongs_to :organization_type,  :inverse_of => :organizations
  has_many :units
  has_many :users
  has_many :main_processes
  has_many :budget_programs
  has_many :rpts
  has_many :unit_rpt_assignations

  def self.select_options(organization_type=nil)
    if organization_type.present?
      self.where(id: OrganizationType.find(organization_type.id).organizations.ids).collect { |v| [ v.description, v.id ] }
    else
      self.all.collect { |v| [ v.description, v.id ] }
    end
  end

  def select_units
      self.units.collect { |v| [ v.description_sap, v.id ] }
  end

  def organizations_authorizated
    current_user.auth_organizations.collect { |v| [ v.description, v.id ] }
  end
end
