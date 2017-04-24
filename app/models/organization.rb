class Organization < ActiveRecord::Base
  resourcify
  belongs_to :organization_type
  has_many :units
  has_many :users
  has_many :main_processes

  def self.select_options(organization_type=nil)
    if organization_type.present?
      self.where(id: OrganizationType.find(organization_type.id).organizations.ids).collect { |v| [ v.description, v.id ] }
    else
      self.all.collect { |v| [ v.description, v.id ] }
    end
  end

  def organizations_authorizated
    current_user.auth_organizations.collect { |v| [ v.description, v.id ] }
  end
end
