class UnitType < ActiveRecord::Base
  has_many :sub_processes
  has_many :units
  belongs_to :organization_type
end
