class AssignedEmployeesChange < ActiveRecord::Base
  belongs_to :period
  belongs_to :unit

  scope :not_verified,  -> { where(:verified_at => nil) }
#  scope :verified,      -> { where(:verified_at => !nil) }

  def self.unit_justified(unit_id, period_id)
    AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).count > 0
  end

  def self.update(period, unit, justification, current_user)
    ae = AssignedEmployeesChange.find_or_create_by(period_id: period.id, unit_id: unit.id)
    ae.justified_by = current_user.login
    ae.justified_at = Time.now
    ae.justification = justification
    ae.save
  end

  def self.cancel(period, unit)
     self.where(period: period, unit: unit).delete_all
  end

  def self.initialize_change(period_id, unit_id, current_user)
    self.create(period_id: period_id, unit_id: unit_id, justified_by: current_user.login)
  end

  def change_justification(period, unit, justification, current_user)
    unless justification.empty?
     AssignedEmployeesChange.find_or_create_by(period_id: period.id, unit_id: unit.id, justification: justification, updated_by: current_user)
    end
  end
end