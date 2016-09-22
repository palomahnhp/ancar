class AssignedEmployee < ActiveRecord::Base
  belongs_to :staff, polymorphic: true
  belongs_to :official_group
  belongs_to :period

  validates_inclusion_of :staff_of_type, in: ["Unit", "SubProcess"]
end