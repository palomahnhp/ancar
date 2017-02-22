class ProcessName < ActiveRecord::Base
  belongs_to :organization_type

  validates_inclusion_of :model, in: ["MainProcess", "SubProcess", "Indicator"]

end
