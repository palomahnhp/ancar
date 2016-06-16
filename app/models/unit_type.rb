class UnitType < ActiveRecord::Base
  has_many :sub_processes
  has_many :units
end
