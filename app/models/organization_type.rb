class OrganizationType < ActiveRecord::Base
  has_many :organizations
  has_many :periods
  has_many :unit_types
  has_many :main_processes, through: :periods
end
