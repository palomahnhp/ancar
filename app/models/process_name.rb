class ProcessName < ActiveRecord::Base
  belongs_to :organization_type

  validates_inclusion_of :model, in: ["main_processes", "sub_processes", "indicators", "indicator_metrics"]

end
