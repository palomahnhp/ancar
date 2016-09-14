class OrganizationType < ActiveRecord::Base
  has_many :organizations
  has_many :periods
  has_many :unit_types
  has_many :main_processes, through: :periods
  has_many :users, through: :manager_organization_types

  validates :description, presence: true
  validates :acronym, presence: true

end
