class Approval < ActiveRecord::Base

  belongs_to :period
  belongs_to :unit

  scope :by_period, -> (period) { where( period: period) }

  def self.by_period_and_unit(period, unit)
    Approval.where(period: period, unit: unit).take
  end

  def self.add(period, unit, comment, user)
    approval = Approval.find_or_create_by(period: period, unit: unit)
    approval.approval_at = Date.today if approval.approval_at.nil?
    approval.approval_by = user.login
    approval.official_position = user.official_position
    approval.comment =  comment
    if approval.changed?
      approval.save
    end
    return approval
  end

  def self.delete(period, unit)
    self.where(period: period, unit: unit).delete_all
  end
end
