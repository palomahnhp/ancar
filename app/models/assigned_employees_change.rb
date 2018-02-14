class AssignedEmployeesChange < ActiveRecord::Base
  belongs_to :period
  belongs_to :unit

  scope :not_verified,  -> { where(:verified_at => nil) }
  scope :by_period, ->(period) { where( period: period) }
  scope :by_unit,   ->(unit)   { where( unit: unit) }

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
    self.create(period_id: period_id, unit_id: unit_id, justified_by: current_user.login,
                justified_at: Date.today)
  end

  def self.change_justification(period_id, unit_id, justification, current_user)
    change_reg = self.find_or_create_by(period_id: period_id, unit_id: unit_id)
    change_reg.assign_attributes(justification: justification, justified_by: current_user.login)
    if change_reg.changed?
      change_reg.justified_at= Date.today
      change_reg.save
    end
    justification.blank?
  end

  def self.emailed(period_id, unit_id)
    ae = find_by(period_id: period_id, unit_id: unit_id)
    ae.emailed_at = Time.now
    ae.save
  end
end