class Approval < ActiveRecord::Base

  belongs_to :period
  belongs_to :unit

  def self.by_period_and_unit(period, unit)
    Approval.where(period: period, unit: unit).take
  end

end
