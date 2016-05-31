class AssignedEmployee < ActiveRecord::Base
  belongs_to :staff, polymorphic: true
  belongs_to :offical_groups

  validates_inclusion_of :staff_of_type, in: ["Unit", "SubProcess"]
end