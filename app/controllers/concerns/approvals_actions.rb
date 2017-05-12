module ApprovalsActions
  extend ActiveSupport::Concern

  def get_approval(period, unit)
    Approval.by_period_and_unit(period, unit)
  end
end