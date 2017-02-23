class OrganizationType < ActiveRecord::Base
  resourcify
  has_many :organizations
  has_many :periods
  has_many :unit_types
  has_many :main_processes, through: :periods
  has_many :users, through: :manager_organization_types
  has_many :process_names

  validates :description, presence: true
  validates :acronym, presence: true

  def authorized_organization_types
    current_user.auth_organization_types.collect { |v| [ v.description, v.id ] }
  end
end
