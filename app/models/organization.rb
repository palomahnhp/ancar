class Organization < ActiveRecord::Base
  resourcify
  belongs_to :organization_type
  has_many :units
  has_many :users
  has_many :main_processes

  def self.select_options
    self.all.collect { |v| [ v.description, v.id ] }
  end

  def self.select_options(organization_type)
    self.where(id: OrganizationType.find(organization_type).organizations.ids).collect { |v| [ v.description, v.id ] }
  end

  def organizations_authorizated
    current_user.auth_organizations.collect { |v| [ v.description, v.id ] }
  end
end
