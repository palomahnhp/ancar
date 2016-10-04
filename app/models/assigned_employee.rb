class AssignedEmployee < ActiveRecord::Base
  belongs_to :staff_of, polymorphic: true
  belongs_to :official_group
  belongs_to :period

  validates_inclusion_of :staff_of_type, in: ["Unit", "SubProcess"]

  def copy(period_destino_id, current_user_login)
    ae = AssignedEmployee.create(self.attributes.merge(id: nil, period_id: period_destino_id, updated_at: current_user_login))
  end
end
